unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,db, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.ComCtrls, Datasnap.DBClient,System.Generics.Collections,System.Generics.Defaults,System.DateUtils,
  Vcl.ExtCtrls,Strutils;

type
  TForm1 = class(TForm)
    DBGrid1: TDBGrid;
    Button1: TButton;
    EndTime: TDateTimePicker;
    Edit1: TEdit;
    DataSource1: TDataSource;
    MainDataSet: TClientDataSet;
    Button2: TButton;
    StartTime: TDateTimePicker;
    TrayIcon1: TTrayIcon;
    FTimer : TTimer;
    ChildTimer: TTimer;
    DataSource2: TDataSource;
    BreakDataSet: TClientDataSet;
    DBGrid2: TDBGrid;
    Edit2: TEdit;
    BreakSTime: TDateTimePicker;
    BreakETime: TDateTimePicker;
    Button3: TButton;
    Button4: TButton;
    Edit3: TEdit;
    Edit4: TEdit;
    Button5: TButton;
    Button6: TButton;
    procedure AddTask(Sender: TObject);
    procedure AddBreak(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PersistDatatoFile();
    procedure FormShow(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure DeleteTask(Sender: TObject);
    procedure DeleteBreak(Sender: TObject);
    procedure SortMainTasks();
    procedure OnTimer(Sender: TObject);
    procedure TrayNotification();
    procedure UpdateMaininterval(Sender: TObject);
    procedure UpdateChildInterval(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadData();
  end;

  IMainInterrface = interface
    function getTaskName() : String;
    procedure setTaskName(Value: String);
    function getStartTime() : TDateTime;
    procedure setStartTime(Value: TDateTime);
    function getEndTime() : TDateTime;
    procedure setEndTime(Value: TDateTime);
  end;

  TClass = class(TInterfacedObject,IMainInterrface)
  private
    FTaskName : String;
    FStartTime : TTime;
    FEndTime : TTime ;
    function getTaskName() : String;
    procedure setTaskName(Value: String);
    function getStartTime() : TDateTime;
    procedure setStartTime(Value: TDateTime);
    function getEndTime() : TDateTime;
    procedure setEndTime(Value: TDateTime);

  published
    property TaskName : String read getTaskName write setTaskName;
    property StartTime: TDateTime read getStartTime write setStartTime;
    property EndTime : TDateTime read getEndTime write setEndTime;
  end;

  TNotification = class(TThread)
    procedure Execute; override;
    procedure ChildTrayNotification(Sender: TObject);
  end;

  TBreakClass = class(TClass)

  end;

var
  Form1: TForm1;
  TaskClass : TClass;
  BreakClass : TBreakClass;
  TaskList : TObjectList<TClass>;
  BreakList : TObjectList<TBreakClass>;
  aThread: TNotification;
  NotificationMainthreadMessage, NotificationChildThreadMessage : string;
  officeStart : boolean;
  TaskNotifiedCOunt : TObjectDictionary<TClass,Integer>;
implementation

{$R *.dfm}

procedure TForm1.AddBreak(Sender: TObject);
var
  StringList : TStringList;
  FName : string ;
  I : Integer;
begin
  if (Edit2.Text <> '') and (DateTimeToStr(BreakETime.DateTime) <> '') and (DateTimeToStr(BreakSTime.DateTime) <> '' ) then
  begin
    BreakClass := TBreakClass.Create;
    StringList := TStringList.Create;
    ExtractStrings([' '],[],pchar(Edit2.Text),StringList);
    for I := 0 to StringList.Count - 1 do
       FName := FName + StringList[I] + ',';
    StringList.Clear;
    FreeAndNil(StringList);
    BreakClass.setTaskName(FName);
    BreakClass.setStartTime(STartTime.DateTime);
    BreakClass.setEndTime(EndTime.DateTime);
    BreakList.Add(BreakClass) ;
    BreakDataSet.DisableControls;
    BreakDataSet.AppendRecord([Edit2.Text,FormatDateTime('hh:mm:ss',BreakSTime.DateTime),FormatDateTime('hh:mm:ss',BreakETime.DateTime)]);
    BreakDataSet.EnableControls;
  end
  else
    showmessage('missing the one of the parameters to enter');


end;

procedure TForm1.AddTask(Sender: TObject);
var
  StringList : TStringList;
  FName : string ;
  I : Integer;
begin
  if (Edit1.Text <> '') and (DateTimeToStr(StartTime.DateTime) <> '') and (DateTimeToStr(EndTime.DateTime) <> '' ) then
  begin
    TaskClass := TClass.Create;
    StringList := TStringList.Create;
    ExtractStrings([' '],[],pchar(Edit1.Text),StringList);
    for I := 0 to StringList.Count - 1 do
       FName := FName + StringList[I] + ',';
    StringList.Clear;
    FreeAndNil(StringList);
    TaskClass.setTaskName(FName);
    TaskClass.setStartTime(STartTime.DateTime);
    TaskClass.setEndTime(EndTime.DateTime);
    TaskList.Add(TaskClass) ;
    MainDataSet.DisableControls;
    MainDataSet.AppendRecord([Edit1.Text,FormatDateTime('hh:mm:ss',StartTime.DateTime),FormatDateTime('hh:mm:ss',EndTime.DateTime)]);
    MainDataSet.EnableControls;
  end
  else
    showmessage('missing the one of the parameters to enter');
  SortMainTasks;

end;

procedure TForm1.UpdateChildInterval(Sender: TObject);
begin
  if Edit4.Text <> '' then
    ChildTimer.Interval := StrToint(Edit4.Text)
  else
    ChildTimer.Interval := 5*60*1000;
end;

procedure TForm1.UpdateMaininterval(Sender: TObject);
begin
  if Edit3.Text <> '' then
    FTimer.Interval := StrToint(Edit3.Text)
  else
    FTimer.Interval := 5*60*1000;
end;

procedure TClass.setTaskName(Value: String);
begin
      Self.FTaskName := Value;
end;

function TClass.getStartTime: TDateTime;
begin
  result := Self.FStartTime
end;

function TClass.getTaskName: String;
begin
   result := Self.FTaskName
end;

function TClass.getEndTime: TDateTime;
begin
  result := Self.FEndTime;
end;

procedure TClass.setStartTime(Value: TDateTime);
begin
      Self.FStartTime := Value;
end;

procedure TClass.setEndTime(Value: TDateTime);
begin
      Self.FEndTime := Value;
end;

procedure TForm1.DeleteBreak(Sender: TObject);
var
  IndextoDel : Integer;
begin
  IndextoDel := BreakDataSet.RecNo;
  BreakDataSet.DisableControls;
  BreakDataSet.Delete;
  BreakDataSet.EnableControls;
  BreakList.Delete(IndextoDel - 1);
end;

procedure TForm1.DeleteTask(Sender: TObject);
var
  IndextoDel : Integer;
begin
  IndextoDel := MainDataSet.RecNo;
  MainDataSet.DisableControls;
  MainDataSet.Delete;
  MainDataSet.EnableControls;
  TaskList.Delete(IndextoDel - 1);
end;

procedure TForm1.Edit1Exit(Sender: TObject);
begin
  if (Edit1.Text = '') then
  begin
    showmessage('Enter TaskName');
    Edit1.SetFocus;
  end;

end;

procedure TForm1.Edit2Exit(Sender: TObject);
begin
   if (Edit2.Text = '') then
  begin
    showmessage('Enter TaskName');
    Edit1.SetFocus;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PersistDatatoFile();
  FreeAndNil(TaskList);
  TaskNotifiedCOunt.Free;
  aThread.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin 
  TaskList := TObjectList<TClass>.Create;
  BreakList := TObjectList<TBreakClass>.Create;
  TaskNotifiedCOunt := TObjectDictionary<TClass,Integer>.Create();
  if Not(MainDataSet.Active) then
  begin
      MainDataSet.CreateDataSet;
      MainDataSet.Active := True;
  end;
  if not(BreakDataSet.Active) then
  begin
    BreakDataSet.CreateDataSet;
    BreakDataSet.Active := True;
  end;

    FTimer.OnTimer := OnTimer;
    FTimer.Interval := 20*1000;
    FTimer.Enabled := True;
    aThread := TNotification.Create(True);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    LoadData();
    DBGrid2.Columns[1].Font.Color := clBlue;
    DBGrid2.Columns[1].Font.Style := [fsBold];
    DBGrid2.Columns[2].Font.Color := clBlue;
    DBGrid2.Columns[2].Font.Style := [fsBold];
    SortMainTasks;
end;

procedure TForm1.LoadData;
var
  FileName : String;
  FileOBJ : TextFile;
  StringCOntent,FName : String;
  StringList : TStringList;
  SplitDelimeteredString : TArray<String>;
  I : Integer;
begin
     StringList :=  TStringList.Create;
     FileName := 'TaskList';
     if (FileExists(FileName)) then 
     begin
         AssignFile(FileObj,FileName);
         Reset(FileObj); 
         MainDataSet.DisableControls;
         MainDataSet.Insert;
         while not Eof(FileObj) do
         begin
            FName := '';
            ReadLn(FileObj,StringCOntent);
            TaskClass := TClass.Create;
            if(StringCOntent <> '') then
            begin
              ExtractStrings([' '],[],pchar(StringCOntent),StringList);
              SplitDelimeteredString := StringList[0].Split([',']);
              for I := 0 to length(SplitDelimeteredString) - 1 do
                FName :=  FName + SplitDelimeteredString[I] + ' ' ;
              TaskClass.setTaskName(StringList[0]);
              TaskClass.setStartTime(strtoDateTime(StringList[1]));
              TaskClass.setEndTime(strtoDateTime(StringList[2]));
              TaskList.Add(TaskClass);
              MainDataSet.InsertRecord([FName,StringList[1],StringList[2]]);
            end;
            StringList.Clear;
         end;
        MainDataSet.EnableControls;
        FreeAndNil(StringList);
        CloseFile(Fileobj);
     end;

     // Loading Breaks info
     StringList :=  TStringList.Create;
     FileName := 'BreakList';
     if (FileExists(FileName)) then
     begin
         AssignFile(FileObj,FileName);
         Reset(FileObj);
         BreakDataSet.EnableControls;
         BreakDataSet.Insert;
         while not Eof(FileObj) do
         begin
            FName := '';
            ReadLn(FileObj,StringCOntent);
            BreakClass := TBreakClass.Create;
            if(StringCOntent <> '') then
            begin
              ExtractStrings([' '],[],pchar(StringCOntent),StringList);
              SplitDelimeteredString := StringList[0].Split([',']);
              for I := 0 to length(SplitDelimeteredString) - 1 do
                FName :=  FName + SplitDelimeteredString[I] + ' ' ;
              BreakClass.setTaskName(StringList[0]);
              BreakClass.setStartTime(strtoDateTime(StringList[1]));
              BreakClass.setEndTime(strtoDateTime(StringList[2]));
              BreakList.Add(BreakClass);
              BreakDataSet.InsertRecord([FName,StringList[1],StringList[2]]);
            end;
            StringList.Clear;
         end;
        BreakDataSet.EnableControls;
        FreeAndNil(StringList);
        CloseFile(Fileobj);
     end;
     
end;

procedure TForm1.OnTimer(Sender: TObject);
var
I, J,maxnotifiedCOunt: integer;
STime , ETime: TTime;
SYSTime : TTime;
SplitDelimeteredString : TArray<String>;
FName : string;
begin
  if Assigned(TaskList) then
  begin
    for I := TaskList.Count - 1 Downto 0 do
    begin
      STime := Frac(TaskList[I].StartTime);
      ETime := Frac(TaskList[I].EndTime);
      SYSTime := Frac(Now());
      TaskNotifiedCOunt.TryGetValue(TaskList[I], maxnotifiedCOunt);
      if (ContainsText(UpperCase(TaskList[I].TaskName), UpperCase('Office'))) and (STime <= SYSTime ) and (ETime >= SYSTime ) and not(officeStart) then
      begin
        officeStart := true;
        maxnotifiedCOunt := maxnotifiedCOunt + 1;
       if TaskNotifiedCOunt.ContainsKey(TaskList[I]) then
            TaskNotifiedCOunt[TaskList[I]] := maxnotifiedCOunt
        else
            TaskNotifiedCOunt.Add(TaskList[I],maxnotifiedCOunt);
        SplitDelimeteredString := TaskList[I].TaskName.Split([',']);
        for J := 0 to length(SplitDelimeteredString) - 1 do
          FName :=  FName + SplitDelimeteredString[J] + ' ' ;
        NotificationMainthreadMessage := UpperCase(FName);
        TrayNotification();
        if officeStart then
        begin
          ChildTimer.OnTimer := aThread.ChildTrayNotification;
          if Edit4.Text <> '' then
             ChildTimer.Interval := StrToint(Edit4.Text)
          else
            ChildTimer.Interval := 60*1000;
          ChildTimer.Enabled := True;
          aThread.Start;
        end;
      end
      else if(ContainsText(UpperCase(TaskList[I].TaskName), UpperCase('Office'))) and (STime <= SYSTime ) and (ETime <= SYSTime ) and (officeStart) then
      begin
        aThread.Suspended := false;
        ChildTimer.Enabled := false;
        officeStart := false;
      end
      else
      begin
        if (STime <= SYSTime ) and (ETime >= SYSTime ) and (maxnotifiedCOunt < 3) then
        begin
        maxnotifiedCOunt := maxnotifiedCOunt + 1;
        if TaskNotifiedCOunt.ContainsKey(TaskList[I]) then
            TaskNotifiedCOunt[TaskList[I]] := maxnotifiedCOunt
        else
            TaskNotifiedCOunt.Add(TaskList[I],maxnotifiedCOunt);
        SplitDelimeteredString := TaskList[I].TaskName.Split([',']);
        if(length(SplitDelimeteredString) > 0) then
        begin
          for J := 0 to length(SplitDelimeteredString) - 1 do
            FName :=  FName + SplitDelimeteredString[J] + ' ' ;
          NotificationMainthreadMessage :=  FName;
          end;
          TrayNotification;
        end;
      end;

    end;
  end;
end;

procedure TForm1.PersistDatatoFile;
var
  FileName : String;
  FileObj : TextFile;
  i : Integer;
begin
   FileName := 'TaskList';
   if(TaskList.Count > 0)then
   begin
      AssignFile(FileObj,FileName);
      ReWrite(FileObj);
      for i := 0 to TaskList.Count - 1 do
      begin
        Write(FileObj, TClass(TaskList[i]).TaskName + ' ' + FormatDateTime('hh:mm:ss',TClass(TaskList[i]).StartTime) + ' '
        + FormatDateTime('hh:mm:ss',TClass(TaskList[i]).EndTime));
          WriteLn(FileObj);
      end;
      CloseFile(FileObj);
   end;
   FileName := 'BreakList';
   if(BreakList.Count > 0)then
   begin
      AssignFile(FileObj,FileName);
      ReWrite(FileObj);
      for i := 0 to BreakList.Count - 1 do
      begin
        Write(FileObj, TBreakClass(BreakList[i]).TaskName + ' ' + FormatDateTime('hh:mm:ss',TBreakClass(BreakList[i]).StartTime) + ' '
        + FormatDateTime('hh:mm:ss',TBreakClass(BreakList[i]).EndTime));
          WriteLn(FileObj);
      end;
      CloseFile(FileObj);
   end;
end;

procedure TForm1.SortMainTasks();
begin
if(TaskList.Count > 0) then
   begin
      TaskList.Sort(TComparer<TClass>.Construct(
      function (const L, R: TClass): integer
      begin
         Result := CompareDate(L.StartTime, R.StartTime);
      end
));

   end;

end;

procedure TForm1.TrayNotification;
var
I : integer;
STime , ETime: TTime;
SYSTime : TTime;
begin
  Form1.TrayIcon1.BalloonHint := NotificationMainthreadMessage;
  Form1.TrayIcon1.AnimateInterval := 200;
  Form1.TrayIcon1.Visible := True;
  Form1.TrayIcon1.ShowBalloonHint;
end;

{ TNotification }

procedure TNotification.Execute;
begin

end;

procedure TNotification.ChildTrayNotification(Sender: TObject);
var
I ,J , maxnotifiedCOunt: integer;
STime , ETime: TTime;
SYSTime : TTime;
FBreakName : string;
SplitDelimeteredString : TArray<String>;
begin
if Assigned(BreakList) then
begin
  for I := BreakList.Count - 1 Downto 0 do
    begin
      STime := Frac(BreakList[I].StartTime);
      ETime := Frac(BreakList[I].EndTime);
      SYSTime := Frac(Now());
      TaskNotifiedCOunt.TryGetValue(BreakList[I], maxnotifiedCOunt);
      if (STime <= SYSTime ) and (ETime >= SYSTime ) and (officeStart) and (maxnotifiedCOunt < 3)  then
      begin
        maxnotifiedCOunt := maxnotifiedCOunt + 1;
       if TaskNotifiedCOunt.ContainsKey(BreakList[I]) then
            TaskNotifiedCOunt[BreakList[I]] := maxnotifiedCOunt
        else
            TaskNotifiedCOunt.Add(BreakList[I],maxnotifiedCOunt);
        SplitDelimeteredString := BreakList[I].TaskName.Split([',']);
        for J := 0 to length(SplitDelimeteredString) - 1 do
          FBreakName :=  FBreakName + SplitDelimeteredString[J] + ' ' ;
        NotificationChildthreadMessage := UpperCase(FBreakName);
        Form1.TrayIcon1.BalloonHint := NotificationChildThreadMessage;
        Form1.TrayIcon1.AnimateInterval := 200;
        Form1.TrayIcon1.Visible := True;
        Form1.TrayIcon1.ShowBalloonHint;
        end
    end;
end;
end;

end.
