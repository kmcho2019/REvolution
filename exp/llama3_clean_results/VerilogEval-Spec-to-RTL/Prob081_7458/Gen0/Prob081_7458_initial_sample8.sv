module TopModule(
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p1e,
    input p1f,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);

// Directly assign p1y using AND and OR operations
assign p1y = (p1a & p1b & p1c) | (p1d & p1e & p1f);

// Declare intermediate wires for the AND gates' outputs
wire and_p2a_p2b;
wire and_p2c_p2d;

// Assign the AND operations to the intermediate wires
assign and_p2a_p2b = p2a & p2b;
assign and_p2c_p2d = p2c & p2d;

// Assign p2y using the intermediate wires and OR operation
assign p2y = and_p2a_p2b | and_p2c_p2d;

endmodule