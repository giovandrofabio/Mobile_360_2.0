program Pedidos;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unitinicial in 'Unitinicial.pas' {FrmInicial},
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmInicial, FrmInicial);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.