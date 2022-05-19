object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 286
  Width = 397
  object conn: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\Giovandro\Documents\Embarcadero\Studio\Project' +
        's\FontesDelphi\DB\pedidos.db'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 176
    Top = 120
  end
  object qry_geral: TFDQuery
    Connection = conn
    Left = 240
    Top = 128
  end
  object qry_pedido: TFDQuery
    Connection = conn
    Left = 296
    Top = 128
  end
  object qry_cliente: TFDQuery
    Connection = conn
    Left = 248
    Top = 184
  end
end
