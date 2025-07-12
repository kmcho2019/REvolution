module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y,
    output p2y
);

// Approach 1: Using assign statement with logical operations
assign p1y = (p1a & p1b & p1c) | (p1d & p1e & p1f);
assign p2y = (p2a & p2b) | (p2c & p2d);

// Alternatively, we could use wires to store the AND gate outputs
// wire p1and1, p1and2, p2and1, p2and2;
// assign p1and1 = p1a & p1b & p1c;
// assign p1and2 = p1d & p1e & p1f;
// assign p2and1 = p2a & p2b;
// assign p2and2 = p2c & p2d;
// assign p1y = p1and1 | p1and2;
// assign p2y = p2and1 | p2and2;

endmodule