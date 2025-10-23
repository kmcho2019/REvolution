module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    wire select_b = sel_b1 & sel_b2;
    
    // Assign-based implementation
    assign out_assign = select_b ? b : a;
    
    // Always-based implementation
    reg out_always_reg;
    always @(*) begin
        out_always_reg = select_b ? b : a;
    end
    assign out_always = out_always_reg;
endmodule