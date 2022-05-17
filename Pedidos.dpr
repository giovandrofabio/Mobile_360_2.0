program Pedidos;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unitinicial in 'Unitinicial.pas' {FrmInicial},
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitDM in 'UnitDM.pas' {dm: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmInicial, FrmInicial);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
