-- !!!dangerous!!! This scripts deletes ADempiere and iDempiere transactional data. 
-- This script is useful when you need to prepare for go-live and you need to delete all your test data.
-- Be aware this updates all clients including GardenWorld
-- If you are running this script against a database with lots of transactions,
--   it may take a while. Below is a link to creating drop and restore constraints commands that greatly improve speed of this script.
--   http://www.chuckboecking.com/blog/bid/196810/Data-Migration-in-PostgreSQL-and-ADemipere-Open-Source-ERP
-- This script is designed for iDempiere. Be aware that ADempiere and iDempiere differ slightly. You may need to make small changes to accomodate ADempiere. 

-- To run this script from the command line, use this command:
-- sudo -u postgres psql -f chuboe_delete_transactional_data.sql -d idempiere

-- thanks to Rumman to improving the script!!

set search_path to adempiere;

delete from ad_changelog;
delete from c_allocationline;
delete from c_allocationhdr;
Update C_BankAccount Set CurrentBalance = 0;
delete from m_costhistory;
delete from m_costdetail;
delete from m_matchinv;
delete from m_matchpo;
delete from c_payselectionline;
delete from c_payselectioncheck;
delete from c_payselection;

Update C_Invoice set C_Cashline_ID = null;
Update C_Order set C_Cashline_ID = null;

/*Update table c_cashline */

Update C_Cashline set C_Payment_ID = null;
Update C_Cashline set C_Invoice_ID = null;

/* Set Document after JAN to Draft */

update c_cash set processed='N',docstatus='DR',posted='N',docaction='CO' where dateacct > '2016-01-01';
update c_cashline set processed='N';

update c_payment set docstatus='DR',reversal_id=null,isallocated='N',isreconciled='N',docaction='CO',posted='N',isapproved='N',processed='N',processedon=0 where dateacct > '2016-01-01';
update c_invoice set docstatus='DR',reversal_id=null,docaction='CO',posted='N',isapproved='N',processed='N',processedon=0,ispaid='N' where dateacct > '2016-01-01';
update c_invoiceline set processed='N';

update gl_journal set reversal_id=null;

update gl_journal set docstatus='DR',docaction='CO',posted='N',isapproved='N',processed='N',processedon=0 where dateacct > '2016-04-01';
update gl_journalline set processed='N';

update m_inventory  set docstatus='DR',processed='N' where movementdate > '2016-01-01';
update m_inout set docstatus='DR',docaction='CO',posted='N',isapproved='N',processed='N',processedon=0 where movementdate > '2016-01-01';

delete from C_Cashline WHERE C_CashLine.C_Cash_ID IN (select C_Cash_ID FROM C_Cash WHERE C_Cash.docstatus NOT IN ('DR'));
delete from C_Cash WHERE docstatus not in ('DR');

Update c_payment set C_Invoice_ID= null WHERE c_invoice_id IN (SELECT c_invoice_id FROM c_invoice WHERE dateacct < '2016-01-01');

delete from C_CommissionAmt;
delete from C_CommissionDetail;
delete from C_CommissionLine;
delete from C_CommissionRun;
delete from C_Commission;
Delete from c_recurring_run;
Delete from c_recurring;
Delete from s_timeexpenseline;
Delete from s_timeexpense;
Delete from c_landedcostallocation;
Delete from c_landedcost;

update c_invoiceline set m_inoutline_id=null;

delete from c_invoiceline WHERE c_invoiceline.c_invoice_id IN (select c_invoice_id FROM c_invoice WHERE docstatus NOT IN ('DR'));

delete from c_invoicetax;
delete from c_paymentallocate;
delete from c_bankstatementline;
delete from c_bankstatement;
Update c_invoice set c_Payment_ID = null;
Update c_order set c_Payment_ID= null;
delete from c_depositbatchline;
delete from c_depositbatch;
delete from c_orderpayschedule;
delete from c_paymenttransaction;

delete from c_payment where docstatus NOT IN ('DR');

delete from c_paymentbatch ;
Update M_INOUTLINE Set C_Orderline_ID = null, M_RMALine_ID=null ;
Update M_INOUT Set C_Order_ID = null, C_Invoice_ID=null, M_RMA_ID=null;
Update C_INVOICE Set M_RMA_ID = null;
update R_Request set m_rma_id = null;
delete from m_rmatax;
delete from M_RMAline;
delete from M_RMA;

delete from c_Invoice WHERE docstatus NOT IN ('DR');


delete from PP_MRP ;
delete from m_requisitionline  ;
delete from m_requisition ;
update pp_order set c_orderline_id = null;
--delete from c_orderline ;
--delete from c_ordertax ;
update r_request set c_order_id = null, M_inout_id = null ;
update r_requestaction set c_order_id = null, M_inout_id = null ;
--delete from c_order ;
delete from fact_acct ;
delete from fact_acct_summary ;
delete from gl_journalbatch ;

delete from gl_journal WHERE docstatus NOT IN ('DR');
delete from gl_journalline WHERE gl_journal_id NOT IN (SELECT gl_journal_id FROM gl_journal WHERE docstatus='DR');


--delete from m_storage ;  -- use this for ADempiere
delete from m_storageonhand;
delete from m_storagereservation;
delete from m_transaction ;
delete from m_packageline ;
delete from m_package ;

delete from m_inoutline WHERE m_inout_id NOT IN (SELECT m_inout_id FROM m_inout WHERE docstatus='DR');
delete from m_inout WHERE docstatus NOT IN ('DR');

delete from m_inoutconfirm ; 
delete from m_inoutlineconfirm ; 
delete from m_inoutlinema ; 

delete from m_inventoryline WHERE m_inventory_id NOT IN (SELECT m_inventory_id FROM m_inventory WHERE docstatus='DR'); 
delete from m_inventory WHERE docstatus NOT IN ('DR');

delete from m_inventorylinema  ; 
delete from m_Movementline ; 
delete from m_Movement ; 
delete from m_Movementconfirm ; 
delete from m_Movementlineconfirm ; 
delete from m_Movementlinema ; 
delete from m_production ;
delete from m_productionplan ; 
delete from m_productionline ; 
delete from c_dunningrun ; 
delete from c_dunningrunline ; 
delete from c_dunningrunentry ; 
delete from AD_WF_EventAudit  ;
delete from AD_WF_Process  ;
Update M_Cost SET CurrentQty=0, CumulatedAMT=0, CumulatedQty=0  ;
Update C_BPartner SET ActualLifetimeValue=0, SO_CreditUsed=0, TotalOpenBalance=0  ;
delete from R_RequestUpdates ;
delete from R_RequestUpdate ;
delete from R_RequestAction ;
delete from R_Request ;
Delete from pp_cost_collectorma  ;
Delete from pp_order_nodenext  ;
Delete from pp_order_node_trl  ;
Delete from pp_order_workflow_trl  ;
Delete from pp_order_bomline_trl  ;
Delete from pp_order_bom_trl  ;
update pp_cost_collector set pp_order_bomline_id = null;
Delete from pp_order_bomline  ;
Delete from pp_order_bom  ;
Delete from PP_Cost_Collector  ;
Update pp_order_workflow set PP_Order_Node_id = null; 
Delete from PP_Order_Node ;
Delete from PP_Order_Workflow  ;
Delete from pp_order_cost  ;
Delete from PP_Order   ;
delete from dd_orderline;
delete from dd_order;
delete from t_replenish;
delete from i_order;
delete from i_invoice;
delete from i_payment;
delete from I_Inventory;
delete from I_GLJournal;
delete from m_distributionrunline;
delete from c_rfqline;
--delete from c_projectline;
--delete from c_project;
