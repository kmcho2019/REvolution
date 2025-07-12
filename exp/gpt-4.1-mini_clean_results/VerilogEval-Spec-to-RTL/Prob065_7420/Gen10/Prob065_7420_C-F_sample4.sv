module nand4 (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire y
);
    // 4-input NAND gate implementation
    assign y = ~(a & b & c & d);
endmodule

module TopModule(
    input  wire p1a,
    input  wire p1b,
    input  wire p1c,
    input  wire p1d,
    input  wire p2a,
    input  wire p2b,
    input  wire p2c,
    input  wire p2d,
    output wire p1y,
    output wire p2y
);

    // Instantiate first 4-input NAND gate replicating first half of 7420 chip
    nand4 nand_gate1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Instantiate second 4-input NAND gate replicating second half of 7420 chip
    nand4 nand_gate2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule