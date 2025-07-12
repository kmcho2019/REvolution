module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);

    // Continuous assignment with clear ternary operator
    assign out_assign = (sel_b1 & sel_b2) ? b : a;

    // Procedural assignment with concise always block
    always @(*) out_always = (sel_b1 & sel_b2) ? b : a;

endmodule