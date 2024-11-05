program ConceptDemo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  WinApi.Windows,
  Demo.Classes in 'Demo.Classes.pas';

var
  FEvent: THandle;

function ConsoleEventProc(CtrlType: DWORD): BOOL; stdcall;
begin
  if (CTRL_CLOSE_EVENT = CtrlType) or (CTRL_C_EVENT = CtrlType) then
  begin
    SetEvent(FEvent);
  end;
  Result := True;
end;

begin
  SetConsoleCtrlHandler(@ConsoleEventProc, True);

  FEvent := CreateEvent(nil, TRUE, FALSE, nil);
  try
    Writeln('Create List');

    // Throw in some arbitrary scope. We can do this in Pascal,
    // just like C++
    begin
      var LFunc := GetDemoArray; // LFunc is a "function: TArray<TMyDemo>>
      Writeln('Got the CreateArray function Reference');
      // Execute the function. The function will exectue but the local variables
      // in it will not go out of scope since the reference to it (LFunc) is still
      // in scope here.
      var LArray := LFunc();
      Writeln('CreateArray executed to return function that returns the TArray ');
      for var i := 0 to (Length(LArray) - 1) do
        Writeln('Found Instance ', (LArray[i] as TMyDemo).InstanceNumber);
      Writeln('Iterated');
    end; // LFunc now out of scope so now all the variables in it (Including the IObjectList implementation)
         // go out of scope and the objects it contains, that we referenced in the for loop are freed at
         // that point
    Writeln('WaitForSingleObject');
    WaitForSingleObject(FEvent, INFINITE);
    CloseHandle(FEvent);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
