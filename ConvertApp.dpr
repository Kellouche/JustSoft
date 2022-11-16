program ConvertApp;

uses
  System.StartUpCopy,
  FMX.Forms,
  ConvertAppDelphi.MainUnit in 'ConvertAppDelphi.MainUnit.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
