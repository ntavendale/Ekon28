object dmMain: TdmMain
  Height = 600
  Width = 800
  PixelsPerInch = 120
  object connDogs: TFDConnection
    Params.Strings = (
      'LockingMode=Normal'
      'Database=C:\Development\Ekon28\RTTISampleApp\Win32\Debug\Dogs.db'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 280
    Top = 130
  end
  object qResetDogs: TFDQuery
    Connection = connDogs
    SQL.Strings = (
      'DROP TABLE IF EXISTS Dog;'
      ''
      'CREATE TABLE Dog ('
      '  DogId INTEGER PRIMARY KEY AUTOINCREMENT,'
      '  Name TEXT,'
      '  Breed TEXT,'
      '  Sex TEXT'
      ');'
      ''
      
        'Insert Into Dog (Name, Breed, Sex) Values ("Butch", "Labrador", ' +
        '"M");'
      
        'Insert Into Dog (Name, Breed, Sex) Values ("Sally", "Beagle", "F' +
        '");'
      
        'Insert Into Dog (Name, Breed, Sex) Values ("Bill", "Poodle", "M"' +
        ');')
    Left = 500
    Top = 180
  end
  object connCats: TFDConnection
    Params.Strings = (
      'Database=C:\Development\Ekon28\RTTISampleApp\Win32\Debug\Cats.db'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 220
    Top = 290
  end
  object qResetCats: TFDQuery
    Connection = connCats
    SQL.Strings = (
      'DROP TABLE IF EXISTS Cat;'
      ''
      'CREATE TABLE Cat ('
      '  CatId INTEGER PRIMARY KEY AUTOINCREMENT,'
      '  Name TEXT,'
      '  Breed TEXT,'
      '  Sex TEXT'
      ');'
      ''
      
        'Insert Into Cat (Name, Breed, Sex) Values ("Mr Tinkles", "Calico' +
        '", "M");'
      
        'Insert Into Cat (Name, Breed, Sex) Values ("Alice", "Tabbey", "F' +
        '");'
      
        'Insert Into Cat (Name, Breed, Sex) Values ("Chester", "Siamese",' +
        ' "M");')
    Left = 470
    Top = 380
  end
end
