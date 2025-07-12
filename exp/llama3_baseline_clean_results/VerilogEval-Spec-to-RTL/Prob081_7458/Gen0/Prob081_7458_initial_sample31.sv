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

// Method 1: Using assign statements directly
assign p1y = (p1a & p1b & p1c) | (p1d & p1e & p1f);
assign p2y = (p2a & p2b) | (p2c & p2d);

// Alternatively, using intermediate wires for better readability
// wire and1, and2, and3, and4;
// assign and1 = p1a & p1b & p1c;
// assign and2 = p1d & p1e & p1f;
// assign and3 = p2a & p2b;
// assign and4 = p2c & p2d;
// assign p1y = and1 | and2;
// assign p2y = and3 | and4;

endmodule