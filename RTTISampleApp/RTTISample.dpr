program RTTISample;

uses
  Vcl.Forms,
  Main in 'Main.pas' {fmMain},
  DemoTypes in 'DemoTypes.pas',
  DataModule in 'DataModule.pas' {dmMain: TDataModule},
  DemoAttributes in 'DemoAttributes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TdmMain, dmMain);
  Application.Run;
end.
