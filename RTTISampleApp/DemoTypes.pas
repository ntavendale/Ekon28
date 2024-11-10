unit DemoTypes;

interface

uses
  System.SysUtils, System.Classes, System.Rtti, System.TypInfo,
  System.Generics.Collections, DemoAttributes, Vcl.Controls;

type
  TSum = class
  private
    class var FCurrentSum: Integer;
  public
    procedure DoAdd([IntValueList('1,2,3')] AValue: Integer);
    class property CurrentSum: Integer read FCurrentSum;
  end;

  TContainer = class(TPersistent)
  private
    FList: TList<TValue>;
    function GetCount: Integer;
    procedure DoFreeObjects;
    function GetItem(AIndex: Integer): TValue;
    procedure SetItem(AIndex: Integer; AValue: TValue);
  public
    MyIntegerProp: Integer;
    constructor Create;
    destructor Destroy; override;
    procedure Add(AValue: TValue); overload;
    procedure Add(AValue: UInt64); overload;
    procedure Add(AValue: Int64); overload;
    procedure Add(AValue: Integer); overload;
    procedure Add(AValue: Cardinal); overload;
    procedure Add(AValue: String); overload;
    procedure Add(AValue: Boolean); overload;
    procedure Add(AValue: TObject); overload;
    property Count: Integer read GetCount;
    property Items[AIndex: Integer]: TValue read GetItem write SetItem; default;
  end;

  TAnimal = class
  protected
    FLegs: Integer;
  public
    constructor Create(ALegs: Integer);
    function GetPropertyLabel(APropertyName: String): String;
    property Legs: Integer read FLegs;
  end;

  TDog = class(TAnimal)
  public
    [DisplayName('Paws')]
    property Legs: Integer read FLegs;
  end;

  THorse = class(TAnimal)
  public
    [DisplayName('Hoofs')]
    property Legs: Integer read FLegs;
  end;

  TObjectClone = record
    class function From<T: class>(Source: T): T; static;
  end;

implementation

{$REGION 'TSum'}
procedure TSum.DoAdd(AValue: Integer);
begin
  FCurrentSum := FCurrentSum + AValue;
  var LRttiContext := TRttiContext.Create;
   try
     for var LParam in LRttiContext.GetType(Self.ClassType).GetMethod('DoAdd').GetParameters do
     begin
       // Attribute constructors run "lazily" - when they are referenced in code
       for var LAttribute in LParam.GetAttributes do
       begin
         if LAttribute is IntValueList then
         begin
           var LIntValueList := (LAttribute as IntValueList);
           for var i := 0 to (LIntValueList.Count - 1) do
             FCurrentSum := FCurrentSum + (AValue shl LIntValueList[i]);
         end;
       end;
     end;
     // Where are the IntValueList Attributes freed? The aren't Rtti Objects and they don't implement any interfaces.
     // Get Attributes creates an array of Attribute objects and sets it as the property of a TFinalizer.
   finally
     LRttiContext.Free;
   end;
end;
{$ENDREGION}

{$REGION 'TContainer'}
constructor TContainer.Create;
begin
  FList := TList<TValue>.Create;
end;

destructor TContainer.Destroy;
begin
  DoFreeObjects;
  FList.Free;
  inherited Destroy;
end;

function TContainer.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TContainer.GetItem(AIndex: Integer): TValue;
begin
  Result := FList[AIndex];
end;

procedure TContainer.SetItem(AIndex: Integer; AValue: TValue);
begin
  // Do check. Earlier versions of Delphi simpley returned nil
  // when AsObject was called on a non object. Later versions
  // throw an excveption.
  // Add a type check for version independence.
  if tkClass = Flist[AIndex].Kind then
  begin
    var Lobj := Flist[AIndex].AsObject;
    if nil <> Lobj then
      FreeAndNil(Lobj);
  end;
  FList[AIndex] := AValue;
end;

procedure TContainer.DoFreeObjects;
begin
  for var i := 0 to (FList.Count -1) do
  begin
    if Flist[i].Kind <> tkClass then
      CONTINUE;
    var Lobj := Flist[i].AsObject;
    if nil <> Lobj then
      FreeAndnil(Lobj);
  end;
end;

procedure TContainer.Add(AValue: TValue);
begin
  FList.Add(AValue);
end;

procedure TContainer.Add(AValue: UInt64);
begin
  var LVal: TValue;
  TValue.Make<Uint64>(AValue, LVal);
  FList.Add(LVal);
end;

procedure TContainer.Add(AValue: Int64);
begin
  var LVal: TValue;
  TValue.Make<Int64>(AValue, LVal);
  FList.Add(LVal);
end;

procedure TContainer.Add(AValue: Integer);
begin
  var LVal: TValue;
  TValue.Make<Integer>(AValue, LVal);
  FList.Add(LVal);
end;

procedure TContainer.Add(AValue: Cardinal);
begin
  var LVal: TValue;
  TValue.Make<Cardinal>(AValue, LVal);
  FList.Add(LVal);
end;

procedure TContainer.Add(AValue: String);
begin
  var LVal: TValue;
  TValue.Make<String>(AValue, LVal);
  FList.Add(LVal);
end;

procedure TContainer.Add(AValue: Boolean);
begin
  var LVal: TValue;
  TValue.Make<Boolean>(AValue, LVal);
  FList.Add(LVal);
end;

procedure TContainer.Add(AValue: TObject);
begin
  var LVal: TValue;
  TValue.Make(@AValue, PTypeInfo(AValue.ClassInfo) , LVal);
  FList.Add(LVal);
end;
{$ENDREGION}

{$REGION 'TAnimal'}
constructor TAnimal.Create(ALegs: Integer);
begin
  FLegs := ALegs;
end;

function TAnimal.GetPropertyLabel(APropertyName: String): String;
begin
  var  LRttiContext := TRttiContext.Create;
  try
    var LRttiType := LRttiContext.GetType(Self.ClassType);
    for var LProp in LRttiType.GetDeclaredProperties do
    begin
      if APropertyName = LProp.Name then
      begin
        for var LAttr in LProp.GetAttributes do
        if LAttr is DisplayName then
        begin
          Result := (LAttr as DisplayName).Name;
          EXIT;
        end;
      end;
    end;
    raise Exception.Create(String.Format('Class %s has no declared property named %s', [Self.ClassName, APropertyName]));
  finally
    LRttiContext.Free;
  end;
end;
{$ENDREGION}

{$REGION 'TObjectClone'}
class function TObjectClone.From<T>(Source: T): T;
begin
  var LParams: TArray<TRttiParameter>;
  var LContext := TRttiContext.Create;
  try
    var LRttiType := LContext.GetType(Source.ClassType);

    // Find a suitable constructor, though treat components as special
    // In this case a suitable constructor is one that
    // a. Takes no parameters or...
    // b. Our object is a component and the parameter passed in is a
    //    parent, or owner, object
    var LIsComponent := (Source is TComponent);
    var LMethod: TRttiMethod := nil;
    for LMethod in LRttiType.GetMethods do
    begin
      if LMethod.IsConstructor then
      begin
        LParams := LMethod.GetParameters;
        if nil = LParams then
          BREAK;

        if (Length(LParams) = 1) and LIsComponent and (LParams[0].ParamType is TRttiInstanceType) and SameText(LMethod.Name, 'Create') then
          BREAK;
      end;
    end;

    // Since the method is a constructor, Result will be an instance of type T
    if nil = LParams then
      Result := LMethod.Invoke(Source.ClassType, []).AsType<T>
    else
      Result := LMethod.Invoke(Source.ClassType, [TComponent(Source).Owner]).AsType<T>;

    try
      // Many VCL control properties require the Parent property to be set first
      if (Source is TControl) then
        (Result as TControl).Parent := (Source as TControl).Parent;

      var LSourceAsPointer, LResultAsPointer: Pointer;

      // Copy the address of the source abnd dest object references to pointers
      Move(Source, LSourceAsPointer, SizeOf(Pointer));
      Move(Result, LResultAsPointer, SizeOf(Pointer));

      var LLookOutForNameProp := LIsComponent and ((Source as TComponent).Owner <> nil);

      var LMinVisibility: TMemberVisibility;
      // loop through the props, copying values across for ones that are read/write
      if LIsComponent then
        LMinVisibility := mvPublished //an alternative is to build an exception list
      else
        LMinVisibility := mvPublic;

      for var LProp in LRttiType.GetProperties do
      begin
        if (LProp.Visibility >= LMinVisibility) and LProp.IsReadable and LProp.IsWritable then
        begin
          if LLookOutForNameProp and (LProp.Name = 'Name') and (LProp.PropertyType is TRttiStringType) then
            // Don't copy the Name property of a component since all components
            // must have uniquree names i.e you can't have two Label1's on a form
            LLookOutForNameProp := False
          else
            // Otherwise set the value on the dest from the source
            LProp.SetValue(LResultAsPointer, LProp.GetValue(LSourceAsPointer));
        end;
      end;
    except
      Result.Free;
      raise;
    end;
  finally
    LContext.Free;
  end;
end;
{$ENDREGION}

end.
