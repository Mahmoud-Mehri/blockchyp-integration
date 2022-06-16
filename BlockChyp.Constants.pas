unit BlockChyp.Constants;

interface

uses
 SysUtils, Classes, Messages;

const
 BLOCKCHYP_URL_TEST = 'https://test.blockchyp.com';
 BLOCKCHYP_URL_MAIN = 'https://api.blockchyp.com';

 BLOCKCHYP_PATH_HEARTBEAT = '/api/heartbeat';
 BLOCKCHYP_PATH_CHARGE = '/api/charge';

 BLOCKCHYP_PATH_REFUND = '/api/refund';
 BLOCKCHYP_PATH_ENROLL = '/api/enroll';
 BLOCKCHYP_PATH_VOID = '/api/void';
 BLOCKCHYP_PATH_REVERSE = '/api/reverse';
 BLOCKCHYP_PATH_PAYMENTLINK = '/api/send-payment-link';
 BLOCKCHYP_PATH_CANCELPAYLINK = '/api/cancel-payment-link';
 BLOCKCHYP_PATH_TXSTATUS = '/api/tx-status';
 BLOCKCHYP_PATH_SIGNATURE = '/api/capture-signature';

 MSG_TRANSACTION_STATUS = WM_USER + 100;
 MSG_TRANSACTION_END    = WM_USER + 101;
 MSG_PAYMENTLINK_END    = WM_USER + 102;
 MSG_PAYMENT_STATUS     = WM_USER + 103;
 MSG_PAYMENTLINK_CANCEL = WM_USER + 104;

implementation

end.
