object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Contact Details'
  ClientHeight = 466
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 24
    Top = 8
    Width = 649
    Height = 145
    DataSource = DataSource1
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Button1: TButton
    Left = 405
    Top = 168
    Width = 89
    Height = 25
    Caption = 'Add Task'
    TabOrder = 3
    OnClick = AddTask
  end
  object EndTime: TDateTimePicker
    Left = 278
    Top = 170
    Width = 121
    Height = 21
    Hint = 'EndTime'
    Date = 44585.783059270830000000
    Time = 44585.783059270830000000
    Kind = dtkTime
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
  object Edit1: TEdit
    Left = 24
    Top = 170
    Width = 121
    Height = 21
    Hint = 'TASKName'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnExit = Edit1Exit
  end
  object Button2: TButton
    Left = 500
    Top = 168
    Width = 89
    Height = 25
    Caption = 'Delete Task'
    TabOrder = 4
    OnClick = DeleteTask
  end
  object StartTime: TDateTimePicker
    Left = 151
    Top = 170
    Width = 121
    Height = 21
    Hint = 'StartTime'
    Date = 44585.783059270830000000
    Time = 44585.783059270830000000
    Kind = dtkTime
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
  end
  object Schedule: TButton
    Left = 595
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Schedule'
    TabOrder = 6
    OnClick = ScheduleClick
  end
  object DBGrid2: TDBGrid
    Left = 24
    Top = 199
    Width = 649
    Height = 145
    DataSource = DataSource2
    ReadOnly = True
    TabOrder = 7
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Edit2: TEdit
    Left = 24
    Top = 350
    Width = 121
    Height = 21
    Hint = 'TASKName'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    OnExit = Edit2Exit
  end
  object BreakSTime: TDateTimePicker
    Left = 151
    Top = 350
    Width = 121
    Height = 21
    Hint = 'BreakSTime'
    Date = 44585.783059270830000000
    Time = 44585.783059270830000000
    Kind = dtkTime
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
  end
  object BreakETime: TDateTimePicker
    Left = 278
    Top = 350
    Width = 121
    Height = 21
    Hint = 'BreakETime'
    Date = 44585.783059270830000000
    Time = 44585.783059270830000000
    Kind = dtkTime
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
  end
  object Button3: TButton
    Left = 405
    Top = 348
    Width = 89
    Height = 25
    Caption = 'Add Break'
    TabOrder = 11
    OnClick = AddBreak
  end
  object Button4: TButton
    Left = 500
    Top = 350
    Width = 89
    Height = 25
    Caption = 'Delete Break'
    TabOrder = 12
    OnClick = DeleteBreak
  end
  object DataSource1: TDataSource
    DataSet = MainDataSet
    Left = 624
    Top = 400
  end
  object MainDataSet: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Task Name'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'StartTime'
        DataType = ftTime
      end
      item
        Name = 'EndTime'
        DataType = ftTime
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 648
    Top = 344
  end
  object TrayIcon1: TTrayIcon
    Left = 752
    Top = 392
  end
  object FTimer: TTimer
    OnTimer = OnTimer
    Left = 688
    Top = 384
  end
  object ChildTimer: TTimer
    Left = 752
    Top = 320
  end
  object DataSource2: TDataSource
    DataSet = BreakDataSet
    Left = 544
    Top = 408
  end
  object BreakDataSet: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Break Name'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'StartTime'
        DataType = ftTime
      end
      item
        Name = 'EndTime'
        DataType = ftTime
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 560
    Top = 352
  end
end
