module FourInputNAND (
    input a,
    input b,
    input c,
    input d,
    output logic y
);
    always_comb begin
        y = ~(a & b & c & d);
    end
endmodule

module TopModule (
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);

    FourInputNAND nand1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    FourInputNAND nand2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule