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

// Using assign statements directly
assign p1y = (p1a & p1b & p1c) | (p1d & p1e & p1f);
assign p2y = (p2a & p2b) | (p2c & p2d);

// Alternatively, using intermediate wires for better readability
// wire and_p1a, and_p1b, and_p2a, and_p2b;
// assign and_p1a = p1a & p1b & p1c;
// assign and_p1b = p1d & p1e & p1f;
// assign and_p2a = p2a & p2b;
// assign and_p2b = p2c & p2d;
// assign p1y = and_p1a | and_p1b;
// assign p2y = and_p2a | and_p2b;

endmodule