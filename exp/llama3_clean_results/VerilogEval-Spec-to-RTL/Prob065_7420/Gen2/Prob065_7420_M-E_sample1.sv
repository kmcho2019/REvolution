module TopModule(
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

// Intermediate signals for the first 4-input NAND gate
wire p1ab;
wire p1abc;

// Intermediate signals for the second 4-input NAND gate
wire p2ab;
wire p2abc;

// Implementing the first 4-input NAND gate using 2-input NAND gates
assign p1ab = ~(p1a & p1b);
assign p1abc = ~(p1ab & p1c);
assign p1y = ~(p1abc & p1d);

// Implementing the second 4-input NAND gate using 2-input NAND gates
assign p2ab = ~(p2a & p2b);
assign p2abc = ~(p2ab & p2c);
assign p2y = ~(p2abc & p2d);

endmodule