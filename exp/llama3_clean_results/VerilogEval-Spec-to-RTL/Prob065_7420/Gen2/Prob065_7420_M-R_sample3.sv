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

// Define internal wires
wire p1_nand;
wire p2_nand;

// Implement NAND logic using internal wires
assign p1_nand = p1a & p1b & p1c & p1d;
assign p2_nand = p2a & p2b & p2c & p2d;

// Assign outputs using internal wires and inversion
assign p1y = ~p1_nand;
assign p2y = ~p2_nand;

endmodule