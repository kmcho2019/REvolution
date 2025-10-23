module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output wire out_always
);

    wire sel_final = sel_b1 & sel_b2;

    // Continuous assignment mux for out_assign
    assign out_assign = sel_final ? b : a;

    // Use assign with ternary operator for out_always (same logic, different style)
    assign out_always = sel_final ? b : a;

endmodule