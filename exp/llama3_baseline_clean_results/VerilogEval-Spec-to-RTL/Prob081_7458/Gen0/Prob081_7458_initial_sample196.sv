module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p1e,
    input  p1f,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

// Declare intermediate wires for the AND gate outputs
wire and_p1_1, and_p1_2, and_p2_1, and_p2_2;

// Drive the intermediate wires with the AND operations
assign and_p1_1 = p1a & p1b & p1c;
assign and_p1_2 = p1d & p1e & p1f;
assign and_p2_1 = p2a & p2b;
assign and_p2_2 = p2c & p2d;

// Drive the output wires with the OR operations on the intermediate wires
assign p1y = and_p1_1 | and_p1_2;
assign p2y = and_p2_1 | and_p2_2;

endmodule