pageextension 50119 ItemListExt extends "Item List"
{
    actions
    {
        addafter(CopyItem)
        {
            action(DeleteDuplicateItems)
            {
                ApplicationArea = All;
                Caption = 'Delete Duplicate Items';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Item: Record Item;
                    TempItem: Record Item temporary;
                    NoOfDuplicateItems: Integer;
                    NoDuplicateItemsMsg: Label 'There are no duplicate items.';
                    NoOfDuplicateItemsDeletedMsg: Label '%1 item(s) were deleted.';
                begin
                    if Rec.FindSet() then
                        repeat
                            TempItem.Reset();
                            TempItem.SetRange(Description, Rec.Description); //Filter duplicates
                            if not TempItem.IsEmpty then begin
                                Item.Get(Rec."No.");
                                Item.Delete(true);
                                NoOfDuplicateItems := NoOfDuplicateItems + 1;
                            end else begin
                                TempItem.Init();
                                TempItem := Rec;
                                TempItem.Insert(); //Insert the record to the temporary table, the first inserted record will be retained
                            end;
                        until Rec.Next = 0;
                    if NoOfDuplicateItems = 0 then
                        Message(NoDuplicateItemsMsg)
                    else
                        Message(NoOfDuplicateItemsDeletedMsg, NoOfDuplicateItems);
                end;
            }
        }
    }
}
