module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Hierarchical selection logic with priority encoding
    wire primary_select = sel_b1 & sel_b2;
    wire secondary_select = sel_b1 | sel_b2;
    
    // Final selection with priority to primary_select
    wire select_b = primary_select ? 1'b1 : 
                   (secondary_select ? 1'b0 : 1'b0);
    
    // Assign implementation with voting
    wire assign_out_a = select_b ? b : a;
    wire assign_out_b = select_b ? b : a;
    assign out_assign = (assign_out_a == assign_out_b) ? assign_out_a : a;
    
    // Always implementation with error checking
    reg always_out;
    reg error_flag;
    
    always @(*) begin
        if (primary_select) begin
            always_out = b;
            error_flag = 1'b0;
        end
        else begin
            always_out = a;
            error_flag = secondary_select;
        end
    end
    
    assign out_always = always_out;
    
    // Error detection output (unused but available for expansion)
    // wire selection_error = error_flag;
endmodule