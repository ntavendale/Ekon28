unit DemoAttributes;

interface

uses
  System.SysUtils, System.StrUtils, System.Classes;

type
  IntValueList = class(TCustomAttribute)
  private
    FValues: Array Of Integer;
    function GetCount: Integer;
    function GetValue(AIndex: Integer): Integer;
  public
    // Attribute constructors can only take constants. Cannot use anything that
    // must be evaluated at runtime so dynamic "array of string" is not possible.
    constructor Create(const AArray: String; ASeperator: String = ',');
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Values[AIndex: Integer]: Integer read GetValue; default;
  end;

  DisplayName = class(TCustomAttribute)
  private
    FName: String;
  public
    constructor Create(AName: String);
    property Name: String read FName;
  end;

implementation

constructor IntValueList.Create(const AArray: String; ASeperator: String = ',');
begin
  var LStringArray := SplitString(AArray, ASeperator);
  SetLength(FValues, Length(LStringArray));
  for var i := 0 to (Length(LStringArray) - 1) do
    FValues[i] := StrToInt(LStringArray[i]);
end;

destructor IntValueList.Destroy;
begin
  SetLength(FValues, 0);
  inherited Destroy;
end;


function IntValueList.GetCount: Integer;
begin
  Result := Length(FValues);
end;

function IntValueList.GetValue(AIndex: Integer): Integer;
begin
  Result := FValues[AIndex];
end;

constructor DisplayName.Create(AName: String);
begin
  FName := AName;
end;

end.
