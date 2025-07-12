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

    // Four AND gates as intermediate wires
    wire and1 = p1a & p1b & p1c;
    wire and2 = p1d & p1e & p1f;
    wire and3 = p2a & p2b;
    wire and4 = p2c & p2d;

    // Two OR gates combine the outputs of AND gates
    assign p1y = and1 | and2;
    assign p2y = and3 | and4;

endmodule