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

wire p1_and1, p1_and2;
wire p2_and1, p2_and2;

// First 4-input NAND gate
assign p1_and1 = p1a & p1b;
assign p1_and2 = p1c & p1d;
assign p1y = ~(p1_and1 & p1_and2);

// Second 4-input NAND gate
assign p2_and1 = p2a & p2b;
assign p2_and2 = p2c & p2d;
assign p2y = ~(p2_and1 & p2_and2);

endmodule