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

    // Four AND gates outputs
    wire and_gate1_p1 = p1a & p1b & p1c;
    wire and_gate2_p1 = p1d & p1e & p1f;
    wire and_gate1_p2 = p2a & p2b;
    wire and_gate2_p2 = p2c & p2d;

    // Two OR gates outputs
    assign p1y = and_gate1_p1 | and_gate2_p1;
    assign p2y = and_gate1_p2 | and_gate2_p2;

endmodule