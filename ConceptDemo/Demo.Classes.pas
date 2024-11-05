unit Demo.Classes;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  WinApi.Windows;

type
  TMyDemo = class
  private
    class var FObjectCount: Integer;
  private
    FInstanceNumber: Integer;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property InstanceNumber: Integer read FInstanceNumber;
  end;

  IObjectContainer = interface
    procedure Add(AObj: TObject);
  end;

  TObjectContainer = class(TInterfacedObject, IObjectContainer)
  var
    FList: TObjectList<TObject>;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Add(AObj: TObject);
  end;

 // function that returns a function: TArray<TMyDemo>
function GetDemoArray: TFunc<TArray<TMyDemo>>;

implementation

function GetDemoArray: TFunc<TArray<TMyDemo>>;
  function CreateArray: TFunc<TArray<TMyDemo>>;
  var
    Larr: TArray<TMyDemo>;
    LList: IObjectContainer;
  begin
    Result := function: TArray<TMyDemo>
    begin
      SetLength(Larr, 3);
      Larr[0] := TMyDemo.Create;
      Larr[1] := TMyDemo.Create;
      Larr[2] := TMyDemo.Create;
      LList:= TObjectContainer.Create;
      for var LMyObj in Larr do
        LList.Add(LMyObj);
      Result := Larr;
    end;
  end;
begin
  // Use brackets at end of function.
  // Result := CreateArray;
  // will give an E2555 incompatable type error.

  // Executes Create Array which returns a function: TArray<TMyDemo>
  /// this function: TArray<TMyDemo> (also written as TFunc<TArray<TMyDemo>>)
  // is then returned to the caller
  Result := CreateArray();
end;

constructor TObjectContainer.Create;
begin
  FList := TObjectList<TObject>.Create(FALSE);
end;

destructor TObjectContainer.Destroy;
begin
  // Free objects in list.
  // Can create list that owns objects and no do this.
  // Put here for demo to make point.
  for var Obj in FList do
    Obj.Free;
  FList.Free;
  inherited Destroy;
end;

procedure TObjectContainer.Add(AObj: TObject);
begin
  FList.Add(AObj);
end;

constructor TMyDemo.Create;
begin
  InterlockedIncrement(FObjectCount);
  FInstanceNumber := FObjectCount;
  Writeln(String.Format('Creating Object Instance %d', [FInstanceNumber]));
end;

destructor TMyDemo.Destroy;
begin
  Writeln(String.Format('Destroying Object Instance %d', [FInstanceNumber]));
  InterlockedDecrement(FObjectCount);
  inherited Destroy;
end;


end.
