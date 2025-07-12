// TopModule replicating the 7420 chip: two independent 4-input NAND gates implemented via cascaded 2-input NANDs
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

    // Internal wires for intermediate NAND outputs for first 4-input NAND
    wire p1_nand_ab;
    wire p1_nand_cd;

    // Internal wires for intermediate NAND outputs for second 4-input NAND
    wire p2_nand_ab;
    wire p2_nand_cd;

    // First 4-input NAND gate implemented as three 2-input NAND gates
    assign p1_nand_ab = ~(p1a & p1b);       // NAND of inputs a and b
    assign p1_nand_cd = ~(p1c & p1d);       // NAND of inputs c and d
    assign p1y        = ~(p1_nand_ab & p1_nand_cd); // NAND of above two results = 4-input NAND

    // Second 4-input NAND gate implemented as three 2-input NAND gates
    assign p2_nand_ab = ~(p2a & p2b);       // NAND of inputs a and b
    assign p2_nand_cd = ~(p2c & p2d);       // NAND of inputs c and d
    assign p2y        = ~(p2_nand_ab & p2_nand_cd); // NAND of above two results = 4-input NAND

endmodule