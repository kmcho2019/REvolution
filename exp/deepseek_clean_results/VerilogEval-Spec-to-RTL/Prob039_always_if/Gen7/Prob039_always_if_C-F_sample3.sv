module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

    // Document the selection condition for clarity
    localparam SEL_B_CONDITION = sel_b1 & sel_b2;

    // Continuous assignment with ternary operator
    assign out_assign = SEL_B_CONDITION ? b : a;

    // Procedural assignment with always block
    always @(*) begin
        out_always = SEL_B_CONDITION ? b : a;
    end

endmodule