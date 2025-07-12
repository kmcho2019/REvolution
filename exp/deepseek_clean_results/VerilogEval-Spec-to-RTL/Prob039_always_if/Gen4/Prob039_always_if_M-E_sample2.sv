module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Configurable selection parameters
    parameter PRIORITY_SEL_B1 = 1;
    parameter PRIORITY_SEL_B2 = 1;
    
    // Priority-encoded selection signal
    wire select_b = (sel_b1 & PRIORITY_SEL_B1) | (sel_b2 & PRIORITY_SEL_B2);
    
    // Assign-based implementation with bitwise selection
    assign out_assign = (select_b & b) | (~select_b & a);
    
    // Procedural implementation with explicit if-else
    always @(*) begin
        if (select_b) begin
            out_always = b;
        end else begin
            out_always = a;
        end
    end
endmodule