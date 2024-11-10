unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.TypInfo, System.Rtti, Vcl.Graphics,  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  DataModule, Vcl.DBCtrls, DemoTypes, Vcl.ExtCtrls;

type
  TfmMain = class(TForm)
    pcMain: TPageControl;
    tsResults: TTabSheet;
    menMain: TMainMenu;
    File1: TMenuItem;
    miExit: TMenuItem;
    ebResults: TEdit;
    tsData: TTabSheet;
    qDogs: TFDQuery;
    qCats: TFDQuery;
    dsDogs: TDataSource;
    dsCats: TDataSource;
    lbdbID: TDBText;
    lbdbName: TDBText;
    lbdbBreed: TDBText;
    lbdbSex: TDBText;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    btnOpen: TButton;
    cbDatabase: TComboBox;
    qDogsID: TFDAutoIncField;
    qDogsName: TWideMemoField;
    qDogsBreed: TWideMemoField;
    qDogsSex: TWideMemoField;
    qCatsId: TFDAutoIncField;
    qCatsName: TWideMemoField;
    qCatsBreed: TWideMemoField;
    qCatsSex: TWideMemoField;
    memOut: TMemo;
    btnTValue: TButton;
    ckbEnabled: TCheckBox;
    btnDoSum: TButton;
    Button1: TButton;
    tsCloneDemo: TTabSheet;
    pnClonedButtons: TPanel;
    btnClone: TButton;
    btnDeclaredAll: TButton;
    procedure miExitClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnOpenClick(Sender: TObject);
    procedure cbDatabaseChange(Sender: TObject);
    procedure btnTValueClick(Sender: TObject);
    procedure ckbEnabledClick(Sender: TObject);
    procedure btnDoSumClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnCloneClick(Sender: TObject);
    procedure btnDeclaredAllClick(Sender: TObject);
  private
    { Private declarations }
    procedure ToggleEnabled(AControlArray: array of TControl; AEnabled: Boolean); overload;
    procedure ToggleEnabled(AControlArray: array of TComponent; AEnabled: Boolean); overload;
    procedure SetDataSource(ADBControlsArray: array of TControl);
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;


implementation

{$R *.dfm}

procedure TfmMain.ToggleEnabled(AControlArray: array of TControl; AEnabled: Boolean);
begin
  for var i := 0 to (Length(AControlArray) - 1) do
    AControlArray[i].Enabled := AEnabled;
end;

procedure TfmMain.ToggleEnabled(AControlArray: array of TComponent; AEnabled: Boolean);
begin
  for var i := 0 to (Length(AControlArray) - 1) do
  begin
    var LComponent := AControlArray[i];
    var LRttiContext := TRttiContext.Create;
    try
      var LRttiType := LRttiContext.GetType(LComponent.ClassType); // returns class reference or metaclass
      var LProperty := LRttiType.GetProperty('Enabled');
      // NOTE: boolean is an enum type
      // type
      //   Boolean = (FALSE, TRUE);
      if (nil <> LProperty) and LProperty.IsWritable and (tkEnumeration = LProperty.DataType.TypeKind) then
      begin
        var LValue := TValue.From(AEnabled);
        LProperty.SetValue(LComponent, LValue);
      end;
    finally
      LRttiContext.Free;
    end;
  end;
end;

procedure TfmMain.SetDataSource(ADBControlsArray: array of TControl);
begin
  var LDataSource: TDataSource;
  case cbDataBase.ItemIndex of
  0: LDataSource := dsCats;
  1: LDataSource := dsDogs;
  end;
  for var i := 0 to (Length(ADBControlsArray) - 1) do
  begin
     var LControl := ADBControlsArray[i];
     var LRttiContext := TRttiContext.Create;
     try
       var LRttiType := LRttiContext.GetType(LControl.ClassType);
       var LProp := LRttiContext.GetType(LControl.ClassType).GetProperty('DataSource');
       if (nil <> LProp) and (LProp.IsWritable) and (tkClass = LProp.DataType.TypeKind) then
       begin
         var LValue: TValue := LRttiType.GetProperty('DataSource').GetValue(LControl);
         TValue.Make(@LDataSource, TypeInfo(TDataSource), LValue);
         LProp.SetValue(LControl, LValue);
       end;
     finally
       LRttiContext.Free;
     end;
  end;
end;

procedure TfmMain.miExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfmMain.btnDeclaredAllClick(Sender: TObject);
begin
  memOut.Lines.Clear;
  var LContext := TRttiContext.Create;
  try
    var LType := LContext.GetType(TButton);
    memOut.Lines.Add('Methods');
    memOut.Lines.Add('===================');
    for var LMethod in LType.GetMethods do
      memOut.Lines.Add(String.Format('%s (%s)', [LMethod.Name, TRttiEnumerationType.GetName(LMethod.MethodKind)]));
    memOut.Lines.Add('Declared Properties');
    memOut.Lines.Add('===================');
    for var LProp in LType.GetDeclaredProperties do
      memOut.Lines.Add(String.Format('%s (%s)', [LProp.Name, TRttiEnumerationType.GetName(LProp.IsWritable)]));
    memOut.Lines.Add('');
    memOut.Lines.Add('Properties');
    memOut.Lines.Add('===================');
    for var LProp in LType.GetProperties do
      memOut.Lines.Add(LProp.Name);
  finally
    LContext.Free;
  end;
end;

procedure TfmMain.btnDoSumClick(Sender: TObject);
begin
  var LSum := TSum.Create;
  try
    LSum.DoAdd(1);
  finally
    LSum.Free;
  end;
  memOut.Lines.Clear;
  memOut.Lines.Add( String.Format('Sum =  %d', [TSum.CurrentSum]) );
  LSum := TSum.Create;
  try
    LSum.DoAdd(1);
  finally
    LSum.Free;
  end;
  memOut.Lines.Clear;
  memOut.Lines.Add( String.Format('Sum =  %d', [TSum.CurrentSum]) );
end;

procedure TfmMain.btnOpenClick(Sender: TObject);
begin
  qDogs.Open;
  qCats.Open;
  cbDataBase.ItemIndex := 0;
  SetDataSource([lbdbID, lbDBName, lbDBBreed, lbdbSex]);
end;

procedure TfmMain.btnTValueClick(Sender: TObject);
begin
  var LSize := Sizeof(TValue);
  memOut.Lines.Clear;
  memOut.Lines.Add( String.Format('SizeOf(TValue) =  %d Bytes', [LSize]) );
end;

procedure TfmMain.cbDatabaseChange(Sender: TObject);
begin
  SetDataSource([lbdbID, lbDBName, lbDBBreed, lbdbSex]);
end;

procedure TfmMain.ckbEnabledClick(Sender: TObject);
begin
  ToggleEnabled([ebResults, btnTValue, miExit], ckbEnabled.Checked);
end;

procedure TfmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (ssCtrl in Shift) and ($44 = Key) then
   begin
     ToggleEnabled([tsResults], ckbEnabled.Checked);
   end;
end;

procedure TfmMain.Button1Click(Sender: TObject);
begin
  var LAnimal: TAnimal := THorse.Create(4);
  try
    memOut.Lines.Add( String.Format('My horse has %d %s', [LAnimal.Legs, LAnimal.GetPropertyLabel('Legs')]) );
  finally
    LAnimal.Free;
  end;
end;

procedure TfmMain.btnCloneClick(Sender: TObject);
begin
  TObjectClone.From(btnClone);
end;

end.
