// Define a basic 2-input NAND gate module
module NAND2(
    input  a,
    input  b,
    output y
);
    assign y = ~(a & b);
endmodule

// Define a 4-input NAND gate module using the 2-input NAND gate
module NAND4(
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
    wire temp1, temp2;
    NAND2 nand1(
        .a(a),
        .b(b),
        .y(temp1)
    );
    NAND2 nand2(
        .a(c),
        .b(d),
        .y(temp2)
    );
    NAND2 nand3(
        .a(temp1),
        .b(temp2),
        .y(y)
    );
endmodule

// The TopModule remains the same, instantiating two NAND4 gates
module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);
    NAND4 nand1(
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );
    NAND4 nand2(
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );
endmodule