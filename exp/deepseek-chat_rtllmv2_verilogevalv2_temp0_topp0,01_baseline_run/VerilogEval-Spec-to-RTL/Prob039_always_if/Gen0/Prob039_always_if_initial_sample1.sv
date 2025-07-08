module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);

    // Implementation using continuous assignment
    assign out_assign = (sel_b1 & sel_b2) ? b : a;

    // Implementation using procedural always block
    reg out_always_reg;
    always @(*) begin
        if (sel_b1 & sel_b2) begin
            out_always_reg = b;
        end else begin
            out_always_reg = a;
        end
    end
    assign out_always = out_always_reg;

endmodule