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

wire and_p1;  // Intermediate wire for the first group
wire and_p2;  // Intermediate wire for the second group

// Perform reduction AND on each 4-input group
assign and_p1 = p1a & p1b & p1c & p1d;
assign and_p2 = p2a & p2b & p2c & p2d;

// Outputs are NAND: negated AND results
assign p1y = ~and_p1;
assign p2y = ~and_p2;

endmodule