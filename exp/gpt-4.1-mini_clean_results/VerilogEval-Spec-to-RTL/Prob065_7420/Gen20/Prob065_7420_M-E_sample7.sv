// Module: nand4_struct
// Description: 4-input NAND gate implemented structurally from 2-input gates.
// The 4-input NAND is implemented as the NAND of (a & b) and (c & d)
module nand4_struct (
    input  a,  // Input bit 1
    input  b,  // Input bit 2
    input  c,  // Input bit 3
    input  d,  // Input bit 4
    output y   // Output bit: NAND of all four inputs
);
    wire ab_and;  // intermediate AND of a and b
    wire cd_and;  // intermediate AND of c and d

    // AND gate for inputs a and b
    and u_and_ab (ab_and, a, b);

    // AND gate for inputs c and d
    and u_and_cd (cd_and, c, d);

    // NAND gate of the two AND outputs to create 4-input NAND
    nand u_nand (y, ab_and, cd_and);

endmodule

// Module: TopModule
// Description: Top-level module implementing the 7420 chip functionality with two structural 4-input NAND gates
module TopModule (
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

    // First 4-input NAND gate instantiation using structural logic
    nand4_struct u_nand1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Second 4-input NAND gate instantiation using structural logic
    nand4_struct u_nand2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule