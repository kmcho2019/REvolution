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

// Four AND gates internal wires
wire and1;
wire and2;
wire and3;
wire and4;

// p1y: OR of two 3-input AND gates
assign and1 = p1a & p1b & p1c;
assign and2 = p1d & p1e & p1f;
assign p1y = and1 | and2;

// p2y: OR of two 2-input AND gates
assign and3 = p2a & p2b;
assign and4 = p2c & p2d;
assign p2y = and3 | and4;

endmodule