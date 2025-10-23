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
    // Four AND gates
    wire and1 = p1a & p1b & p1c;  // 3-input AND for p1y part 1
    wire and2 = p1d & p1e & p1f;  // 3-input AND for p1y part 2
    wire and3 = p2a & p2b;        // 2-input AND for p2y part 1
    wire and4 = p2c & p2d;        // 2-input AND for p2y part 2

    // Two OR gates combine the AND outputs
    assign p1y = and1 | and2;
    assign p2y = and3 | and4;
endmodule