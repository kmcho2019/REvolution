// 3-input OR gate module definition
module Or3 (
    input  x,
    input  y,
    input  z,
    output q
);
    assign q = x | y | z;
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Instantiate 3-input OR gate for output
    Or3 or3_inst (
        .x(a),
        .y(b),
        .z(c),
        .q(out)
    );

endmodule