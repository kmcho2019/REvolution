module TopModule (
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

// Intermediate wires for AND gates
wire and1, and2, and3, and4;

// Four AND gates corresponding to the 7458 chip
assign and1 = p1a & p1b & p1c;   // First 3-input AND for p1y
assign and2 = p1d & p1e & p1f;   // Second 3-input AND for p1y
assign and3 = p2a & p2b;          // First 2-input AND for p2y
assign and4 = p2c & p2d;          // Second 2-input AND for p2y

// OR gates combining the AND outputs for final outputs
assign p1y = and1 | and2;
assign p2y = and3 | and4;

endmodule