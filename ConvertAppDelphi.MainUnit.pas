{
Autor : Kellouche Abdelhakim

--------  VERY IMPORTANT ---------
Don't fortget :
you must subscribe on https://apilayer.com/marketplace/exchangerates_data-api
to get your API Key.}

unit ConvertAppDelphi.MainUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.MultiView, FMX.Layouts,
  FMX.Effects, FMX.Filter.Effects, FMX.ListBox, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, System.JSON,
  System.Generics.Collections, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, IPPeerClient, System.Rtti, FMX.Grid.Style,
  FMX.Grid, FMX.ScrollBox, System.DateUtils, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, Vcl.Dialogs;

type
  TFormMain = class(TForm)
    BtnReFresh: TButton;
    BtnSearch: TButton;
    MultiView1: TMultiView;
    EdtAmount: TEdit;
    BtnRequest: TButton;
    LytMain: TLayout;
    LytBackgroundPic: TLayout;
    RctData: TRectangle;
    Layout1: TLayout;
    ToolBar1: TToolBar;
    Layout2: TLayout;
    LblRate: TLabel;
    GridPanelLayout1: TGridPanelLayout;
    LblEuro: TLabel;
    StyleBook2: TStyleBook;
    MultiView2: TMultiView;
    StringGrid1: TStringGrid;
    Text1: TText;
    Text2: TText;
    lblUpdate: TLabel;
    Image1: TImage;
    Image2: TImage;
    LblResult: TLabel;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    LblUSA: TLabel;
    LblEngland: TLabel;
    LblEAU: TLabel;
    LblKuwait: TLabel;
    LblTunisie: TLabel;
    LblMorroco: TLabel;
    LblEgypt: TLabel;
    RESTResponse2: TRESTResponse;
    RESTRequest2: TRESTRequest;
    RESTClient2: TRESTClient;
    Panel1: TPanel;
    procedure BtnRequestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.fmx}

procedure TFormMain.BtnRequestClick(Sender: TObject);
var
  Convert, info_Convert, rates : TJSONObject;
  timestamp : Int64;
  rate : double;
  result_exchange: double;
  TND_exchange, AED_exchange, EGP_exchange, USA_exchange, KWD_exchange,
  MRO_exchange, QAR_exchange, GBP_exchange : double;
begin
  MultiView1.HideMaster;

  // enter your API key
  RESTClient1.Params.ParameterByName('apikey').Value := 'Your API key here';

  if RESTClient1.Params.ParameterByName('apikey').Value = 'Your API key here' then
  begin
    MessageDlg('Enter your API key before continuing.', mtError, [mbOk], 0, mbOk);
    Application.Terminate;
    Exit;
  end;

  if EdtAmount.Text = '' then
  begin
    RESTClient1.Params.ParameterByName('amount').Value := '1';
  end
  else
  begin
    RESTClient1.Params.ParameterByName('amount').Value := EdtAmount.Text;
  end;
  LblEuro.Text := '1 EURO';
  RESTRequest1.Execute;

  Convert := TJSONObject.ParseJSONValue(RESTResponse1.Content) as TJSONObject;
  try
    info_Convert  := Convert.GetValue<TJSONObject>('info');
    rate          := info_Convert.GetValue<Double>('rate');
    timestamp     := info_Convert.GetValue<Int64>('timestamp');
    result_exchange := Convert.GetValue<Double>('result');

    lblUpdate.Text := 'Data last update ' + DateToStr(UnixToDateTime(timestamp)) +
      ' at ' + TimeToStr(UnixToDateTime(timestamp));
    LblRate.Text :=  Format('Rate : %.2f DZD', [rate]);

    if EdtAmount.Text = '' then
    begin
      LblResult.Visible := False;
    end
    else
    begin
      LblResult.Visible := True;
      lblResult.Text := Format('Result convert : %.2f DZD', [result_exchange]);
    end;
  finally
    Convert.Free;
  end;

  RESTClient2.BaseURL := 'https://api.apilayer.com/exchangerates_data/latest?symbols='+
            'DZD%2C%20TND%2C%20SAR%2C%20QAR%2C%20MRO%2C%20MAD%2C%20LYD%2C%20' +
            'KWD%2C%20GBP%2C%20JPY%2C%20JOD%2C%20%20IQD%2C%20EGP%2C%20CAD%2C%20' +
            'BTC%2C%20BHD%2C%20AED%2C%20USD&base=EUR';

  // enter your API key
  RESTClient2.Params.ParameterByName('apikey').Value := 'Your API key here';

  if RESTClient2.Params.ParameterByName('apikey').Value = 'Your API key here' then
  begin
    MessageDlg('Enter your API key before continuing.', mtError, [mbOk], 0, mbOk);
    Application.Terminate;
    Exit;
  end;

  RESTRequest2.Execute;
  try
    Convert := TJSONObject.ParseJSONValue(RESTResponse2.Content) as TJSONObject;
    rates := Convert.GetValue<TJSONObject>('rates');
    TND_exchange := rates.GetValue<Double>('TND');
    AED_exchange := rates.GetValue<Double>('AED');
    EGP_exchange := rates.GetValue<Double>('EGP');
    USA_exchange := rates.GetValue<Double>('USD');
    KWD_exchange := rates.GetValue<Double>('KWD');
    MRO_exchange := rates.GetValue<Double>('MRO');
    QAR_exchange := rates.GetValue<Double>('QAR');
    GBP_exchange := rates.GetValue<Double>('GBP');
    LblUSA.Text := Format('%.4f $', [USA_exchange]);
    LblEngland.Text := Format('%.4f £', [GBP_exchange]);
    LblTunisie.Text := Format('%.4f TND', [TND_exchange]);
    LblEAU.Text := Format('%.4f AED', [AED_exchange]);
    LblEgypt.Text := Format('%.4f EGP', [EGP_exchange]);
    LblKuwait.Text := Format('%.4f KWD', [KWD_exchange]);
    LblMorroco.Text := Format('%.4f MRO', [MRO_exchange]);
  finally
    Convert.Free;
  end;
end;

end.
