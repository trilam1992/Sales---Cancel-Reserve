// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

codeunit 50000 SalesCancelReserve
{
    trigger OnRun()
    begin
        Message('Test');
        CancelReserve();
    end;

    procedure CancelReserve()
    begin
        salesList := 'DOC';
        salesListWithReserve := 'DOC';
        salesRec.SetRange("Document Type", salesRec."Document Type"::Order);
        salesRec.SetRange("Document Date", Today);
        if salesRec.FindSet() then begin
            repeat
                salesList := salesList + '|' + salesRec."No.";
            until salesRec.Next() = 0;

            reservEntry.SetRange("Reservation Status", reservEntry."Reservation Status"::Reservation);
            reservEntry.SetRange("Source Type", 37);
            reservEntry.SetFilter("Source ID", salesList);
            if reservEntry.FindSet() then begin

                repeat
                    reservEntry2.Get(reservEntry."Entry No.");
                    reservEngine.CancelReservation(reservEntry2);
                    salesListWithReserve := salesListWithReserve + '|' + reservEntry2."Source ID";
                until reservEntry.Next() = 0;
            end;
        end;
        salesRec2.SetFilter("Document Type", Format(salesRec2."Document Type"::Order));
        salesRec2.SetFilter("No.", salesListWithReserve);
        if salesRec.FindSet() then
            salesRec2.DeleteAll(true)
    end;

    var
        custRec: Record Customer;
        reservEntry: Record "Reservation Entry";
        reservEntry2: Record "Reservation Entry";
        salesRec: Record "Sales Header";
        salesRec2: Record "Sales Header";
        archiveMgt: Codeunit ArchiveManagement;
        reservEngine: Codeunit "Reservation Engine Mgt.";
        salesList: Text;
        salesListWithReserve: Text;

}