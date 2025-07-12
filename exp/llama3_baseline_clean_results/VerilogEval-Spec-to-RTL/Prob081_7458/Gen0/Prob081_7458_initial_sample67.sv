module TopModule(
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

// Method 1: Directly using assign statements
assign p1y = (p1a & p1b & p1c) | (p1d & p1e & p1f);
assign p2y = (p2a & p2b) | (p2c & p2d);

// Alternatively, you could explicitly declare wires for the AND gates
// Method 2: Using intermediate wires for clarity
// wire and1, and2, and3, and4;
// assign and1 = p1a & p1b & p1c;
// assign and2 = p1d & p1e & p1f;
// assign and3 = p2a & p2b;
// assign and4 = p2c & p2d;
// assign p1y = and1 | and2;
// assign p2y = and3 | and4;

endmodule