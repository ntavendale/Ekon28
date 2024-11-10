unit DataModule;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TdmMain = class(TDataModule)
    connDogs: TFDConnection;
    qResetDogs: TFDQuery;
    connCats: TFDConnection;
    qResetCats: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    class function GetConnectionDef(ADatabaseName, ADatabasePath: String): String;
  end;

var
  dmMain: TdmMain;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

constructor TdmMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  var LDogPath := IncludeTrailingPathDelimiter( ExtractFileDir(ParamStr(0)) ) + 'Dogs.db';
  var LCatPath := IncludeTrailingPathDelimiter( ExtractFileDir(ParamStr(0)) ) + 'Cats.db';

  connDogs.ConnectionDefname := GetConnectionDef('Dogs', LDogPath);
  connCats.ConnectionDefname := GetConnectionDef('Cats', LCatPath);

  var LResetDogs := TFile.Exists(LDogPath);
  var LResetCats := TFile.Exists(LCatPath);

  connDogs.Connected := TRUE;
  if LResetDogs then
    qResetDogs.ExecSQL;

  connCats.Connected := TRUE;
  if LResetCats then
    qResetCats.ExecSQL;

end;

class function TdmMain.GetConnectionDef(ADatabaseName, ADatabasePath: String): String;
begin
  var LConnectionDef := FDManager.ConnectionDefs.FindConnectionDef(ADatabaseName + '_Connection');

  if nil = LConnectionDef then
  begin
    var LParams := TStringList.Create;
    LParams.Add('Database=' + ADatabasePath);
    FDManager.AddConnectionDef(ADatabaseName + '_Connection', 'SQLite', LParams);
    Result := ADatabaseName + '_Connection';
  end else
  begin
    Result := LConnectionDef.Name;
  end;
end;

end.
