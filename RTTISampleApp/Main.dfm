object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'RTTI Examples'
  ClientHeight = 575
  ClientWidth = 952
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Menu = menMain
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object pcMain: TPageControl
    Left = 0
    Top = 0
    Width = 952
    Height = 575
    ActivePage = tsData
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 950
    ExplicitHeight = 567
    object tsResults: TTabSheet
      Caption = 'Results'
      object ebResults: TEdit
        Left = 16
        Top = 24
        Width = 121
        Height = 23
        TabOrder = 0
        Text = 'ebResults'
      end
      object memOut: TMemo
        Left = 16
        Top = 144
        Width = 913
        Height = 377
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = []
        Lines.Strings = (
          'memOut')
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 1
      end
      object btnTValue: TButton
        Left = 16
        Top = 104
        Width = 75
        Height = 25
        Caption = 'TValue'
        TabOrder = 2
        OnClick = btnTValueClick
      end
      object ckbEnabled: TCheckBox
        Left = 200
        Top = 27
        Width = 73
        Height = 17
        Caption = 'Enabled'
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = ckbEnabledClick
      end
      object btnDoSum: TButton
        Left = 184
        Top = 104
        Width = 75
        Height = 25
        Caption = 'Do Sum'
        TabOrder = 4
        OnClick = btnDoSumClick
      end
      object Button1: TButton
        Left = 408
        Top = 32
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 5
        OnClick = Button1Click
      end
      object btnDeclaredAll: TButton
        Left = 816
        Top = 23
        Width = 99
        Height = 25
        Caption = 'Declared/All'
        TabOrder = 6
        OnClick = btnDeclaredAllClick
      end
    end
    object tsData: TTabSheet
      Caption = 'Data'
      ImageIndex = 1
      object lbdbID: TDBText
        Left = 104
        Top = 88
        Width = 65
        Height = 17
        DataField = 'ID'
        DataSource = dsDogs
      end
      object lbdbName: TDBText
        Left = 104
        Top = 120
        Width = 121
        Height = 17
        DataField = 'Name'
        DataSource = dsDogs
      end
      object lbdbBreed: TDBText
        Left = 104
        Top = 152
        Width = 121
        Height = 17
        DataField = 'Breed'
      end
      object lbdbSex: TDBText
        Left = 104
        Top = 184
        Width = 121
        Height = 17
        DataField = 'Sex'
      end
      object Label1: TLabel
        Left = 8
        Top = 88
        Width = 13
        Height = 15
        Caption = 'ID'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 8
        Top = 120
        Width = 33
        Height = 15
        Caption = 'Name'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 8
        Top = 152
        Width = 34
        Height = 15
        Caption = 'Breed'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 8
        Top = 184
        Width = 21
        Height = 15
        Caption = 'Sex'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btnOpen: TButton
        Left = 16
        Top = 32
        Width = 75
        Height = 25
        Caption = 'Open'
        TabOrder = 0
        OnClick = btnOpenClick
      end
      object cbDatabase: TComboBox
        Left = 128
        Top = 33
        Width = 145
        Height = 23
        Style = csDropDownList
        TabOrder = 1
        OnChange = cbDatabaseChange
        Items.Strings = (
          'Cats'
          'Dogs')
      end
    end
    object tsCloneDemo: TTabSheet
      Caption = 'Cloning'
      ImageIndex = 2
      object pnClonedButtons: TPanel
        Left = 3
        Top = 3
        Width = 938
        Height = 78
        TabOrder = 0
        object btnClone: TButton
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 121
          Height = 70
          Align = alLeft
          Caption = 'Clone Me'
          TabOrder = 0
          OnClick = btnCloneClick
        end
      end
    end
  end
  object menMain: TMainMenu
    Left = 100
    Top = 274
    object File1: TMenuItem
      Caption = 'File'
      object miExit: TMenuItem
        Caption = 'E&xit'
        OnClick = miExitClick
      end
    end
  end
  object qDogs: TFDQuery
    Connection = dmMain.connDogs
    SQL.Strings = (
      'Select DogId as ID, Name, Breed, Sex'
      'From Dog')
    Left = 484
    Top = 114
    object qDogsID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'DogId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object qDogsName: TWideMemoField
      FieldName = 'Name'
      Origin = 'Name'
      BlobType = ftWideMemo
      DisplayValue = dvFull
    end
    object qDogsBreed: TWideMemoField
      FieldName = 'Breed'
      Origin = 'Breed'
      BlobType = ftWideMemo
      DisplayValue = dvFull
    end
    object qDogsSex: TWideMemoField
      FieldName = 'Sex'
      Origin = 'Sex'
      BlobType = ftWideMemo
      DisplayValue = dvFull
    end
  end
  object qCats: TFDQuery
    Connection = dmMain.connCats
    SQL.Strings = (
      'Select CatId As Id, Name, Breed, Sex'
      'From Cat')
    Left = 484
    Top = 242
    object qCatsId: TFDAutoIncField
      FieldName = 'Id'
      Origin = 'CatId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object qCatsName: TWideMemoField
      FieldName = 'Name'
      Origin = 'Name'
      BlobType = ftWideMemo
      DisplayValue = dvFull
    end
    object qCatsBreed: TWideMemoField
      FieldName = 'Breed'
      Origin = 'Breed'
      BlobType = ftWideMemo
      DisplayValue = dvFull
    end
    object qCatsSex: TWideMemoField
      FieldName = 'Sex'
      Origin = 'Sex'
      BlobType = ftWideMemo
      DisplayValue = dvFull
    end
  end
  object dsDogs: TDataSource
    DataSet = qDogs
    Left = 556
    Top = 122
  end
  object dsCats: TDataSource
    DataSet = qCats
    Left = 556
    Top = 242
  end
end
