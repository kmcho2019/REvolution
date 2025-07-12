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

    // Intermediate signals for AND gate outputs (7458 chip internal gates)
    wire and1_p1 = p1a & p1b & p1c;    // First 3-input AND gate for p1y
    wire and2_p1 = p1d & p1e & p1f;    // Second 3-input AND gate for p1y

    wire and1_p2 = p2a & p2b;           // First 2-input AND gate for p2y
    wire and2_p2 = p2c & p2d;           // Second 2-input AND gate for p2y

    // OR gates combining the outputs of the AND gates
    assign p1y = and1_p1 | and2_p1;
    assign p2y = and1_p2 | and2_p2;

endmodule