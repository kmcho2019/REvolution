// 2-input NAND gate primitive module
module nand2 (
    input  a,
    input  b,
    output y
);
    assign y = ~(a & b);
endmodule

// TopModule implements two 4-input NAND gates like 7420 chip
// Each 4-input NAND is built from three 2-input NAND gates structurally
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

    // Internal nets for first NAND gate tree
    wire n1_1, n1_2, n1_3;
    // NAND p1a and p1b
    nand2 n1a (.a(p1a), .b(p1b), .y(n1_1));
    // NAND p1c and p1d
    nand2 n1b (.a(p1c), .b(p1d), .y(n1_2));
    // NAND n1_1 and n1_2
    nand2 n1c (.a(n1_1), .b(n1_2), .y(n1_3));
    // Invert n1_3 by NANDing it with itself (to get 4-input NAND)
    nand2 n1d (.a(n1_3), .b(n1_3), .y(p1y));

    // Internal nets for second NAND gate tree
    wire n2_1, n2_2, n2_3;
    // NAND p2a and p2b
    nand2 n2a (.a(p2a), .b(p2b), .y(n2_1));
    // NAND p2c and p2d
    nand2 n2b (.a(p2c), .b(p2d), .y(n2_2));
    // NAND n2_1 and n2_2
    nand2 n2c (.a(n2_1), .b(n2_2), .y(n2_3));
    // Invert n2_3 by NANDing it with itself
    nand2 n2d (.a(n2_3), .b(n2_3), .y(p2y));

endmodule