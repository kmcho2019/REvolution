module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Shared selection logic - single point of truth
    wire sel_both = sel_b1 & sel_b2;

    // Continuous assignment implementation (clear ternary operator)
    assign out_assign = sel_both ? b : a;

    // Procedural implementation (using same efficient style)
    reg out_always_reg;
    always @(*) begin
        out_always_reg = sel_both ? b : a;
    end
    assign out_always = out_always_reg; // Avoid unnecessary register if interface allows
endmodule