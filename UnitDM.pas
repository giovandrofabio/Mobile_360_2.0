unit UnitDM;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,

  Data.DB,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs,
  FireDAC.FMXUI.Wait,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet;

type
  Tdm = class(TDataModule)
    conn: TFDConnection;
    qry_geral: TFDQuery;
    qry_pedido: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
   with conn do
   begin
      Params.Values['DriverID'] := 'SQLite';
      {$IFDEF IOS}
      Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'pedidos.db');
      {$ENDIF}

      {$IFDEF ANDROID}
      Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'pedidos.db');
      {$ENDIF}

      {$IFDEF MSWINDOWS}
      Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\DB\pedidos.db';
      //Params.Values['Database'] := 'C:\Users\Giovandro\Documents\Embarcadero\Studio\Projects\FontesDelphi\Win32\Debug\DB\pedidos.db';
      {$ENDIF}

      try
         Connected := True;
      except on E: Exception do
         raise Exception.Create('Erro de conex�o com o banco de dados: ' + e.Message);
      end;
   end;
end;

end.
