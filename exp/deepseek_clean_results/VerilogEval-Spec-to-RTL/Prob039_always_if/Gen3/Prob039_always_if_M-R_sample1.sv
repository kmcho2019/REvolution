module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Shared selection logic
    wire select_b = sel_b1 & sel_b2;

    // Assign-based implementation
    assign out_assign = select_b ? b : a;

    // Always-based implementation
    reg out_always_reg;
    always @(*) begin
        if (select_b)
            out_always_reg = b;
        else
            out_always_reg = a;
    end
    
    assign out_always = out_always_reg;
endmodule