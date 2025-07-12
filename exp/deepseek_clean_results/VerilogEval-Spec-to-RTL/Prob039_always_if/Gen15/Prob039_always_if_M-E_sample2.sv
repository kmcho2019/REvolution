module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Common selection logic
    wire select_b = sel_b1 & sel_b2;
    
    // Assign implementation (traditional ternary)
    assign out_assign = select_b ? b : a;
    
    // Always implementation (novel path gating)
    reg out_reg;
    always @(*) begin
        // Gate the 'b' path - only active when selected
        wire gated_b = b & select_b;
        // Gate the 'a' path - active when not selecting b
        wire gated_a = a & ~select_b;
        // Combine the gated paths
        out_reg = gated_b | gated_a;
    end
    
    assign out_always = out_reg;
endmodule