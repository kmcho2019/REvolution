module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Compute selection mask (all 1's when both select signals are true)
    wire select_mask = sel_b1 & sel_b2;
    
    // Assign-based implementation using bitwise operations
    assign out_assign = (a & ~select_mask) | (b & select_mask);
    
    // Always-based implementation using the same technique
    reg out_always_reg;
    always @(*) begin
        out_always_reg = (a & ~select_mask) | (b & select_mask);
    end
    assign out_always = out_always_reg;
endmodule