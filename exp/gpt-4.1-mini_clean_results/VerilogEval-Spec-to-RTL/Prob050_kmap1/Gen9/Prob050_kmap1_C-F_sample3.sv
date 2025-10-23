// 2-input OR gate module definition
module Or2 (
    input  x,
    input  y,
    output q
);
    assign q = x | y;
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    wire ab_or;

    // Instantiate first 2-input OR gate for (a | b)
    Or2 or2_inst1 (
        .x(a),
        .y(b),
        .q(ab_or)
    );

    // Instantiate second 2-input OR gate for ((a | b) | c)
    Or2 or2_inst2 (
        .x(ab_or),
        .y(c),
        .q(out)
    );

endmodule