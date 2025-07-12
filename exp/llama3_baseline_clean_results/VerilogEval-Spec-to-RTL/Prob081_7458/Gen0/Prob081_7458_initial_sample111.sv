module TopModule(
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

// Declare intermediate wires for AND gate outputs
wire and_p1_1, and_p1_2, and_p2_1, and_p2_2;

// Drive the intermediate wires with AND operations
assign and_p1_1 = p1a & p1b & p1c;
assign and_p1_2 = p1d & p1e & p1f;
assign and_p2_1 = p2a & p2b;
assign and_p2_2 = p2c & p2d;

// Drive the outputs with OR operations on the intermediate wires
assign p1y = and_p1_1 | and_p1_2;
assign p2y = and_p2_1 | and_p2_2;

endmodule