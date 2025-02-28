namespace Microsoft.SubscriptionBilling;

using Microsoft.Purchases.History;

pageextension 8074 "Posted Purch Cr. Memo Subform" extends "Posted Purch. Cr. Memo Subform"
{
    actions
    {
        addlast("&Line")
        {
            action(ShowArchivedBillingLines)
            {
                ApplicationArea = All;
                Caption = 'Archived Billing Lines';
                Image = ViewDocumentLine;
                ToolTip = 'Show archived Billing Lines.';
                Scope = Repeater;
                Enabled = IsConnectedToContractLine;

                trigger OnAction()
                begin
                    ContractsGeneralMgt.ShowArchivedBillingLines(Rec."Subscription Contract No.", Rec."Subscription Contract Line No.", Enum::"Service Partner"::Vendor, Enum::"Rec. Billing Document Type"::"Credit Memo", Rec."Document No.");
                end;
            }
            action("Usage Data")
            {
                ApplicationArea = All;
                Caption = 'Usage Data';
                Image = DataEntry;
                Scope = Repeater;
                ToolTip = 'Shows the related usage data.';
                Enabled = UsageDataEnabled;

                trigger OnAction()
                var
                    UsageDataBilling: Record "Usage Data Billing";
                begin
                    UsageDataBilling.ShowForDocuments(Enum::"Service Partner"::Vendor, "Usage Based Billing Doc. Type"::"Posted Credit Memo", Rec."Document No.", Rec."Line No.");
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        UsageDataBilling: Record "Usage Data Billing";
    begin
        IsConnectedToContractLine := ContractsGeneralMgt.HasConnectionToContractLine(Rec."Subscription Contract No.", Rec."Subscription Contract Line No.");
        UsageDataEnabled := UsageDataBilling.ExistForDocuments(Enum::"Service Partner"::Vendor, "Usage Based Billing Doc. Type"::"Posted Credit Memo", Rec."Document No.", Rec."Line No.");
    end;

    var
        ContractsGeneralMgt: Codeunit "Sub. Contracts General Mgt.";
        IsConnectedToContractLine: Boolean;
        UsageDataEnabled: Boolean;
}
