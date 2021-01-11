object DM: TDM
  OldCreateOrder = False
  Height = 143
  Width = 267
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=mv'
      'User_Name=root'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 48
    Top = 24
  end
  object FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink
    VendorLib = 'C:\Users\Edmilson\Documents\Kelmer\wk\libmySQL.dll'
    Left = 144
    Top = 32
  end
  object FDQuery: TFDQuery
    Connection = FDConnection
    Left = 120
    Top = 64
  end
end
