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

    wire and1_3in;
    wire and2_3in;
    wire and1_2in;
    wire and2_2in;

    assign and1_3in = p1a & p1b & p1c;
    assign and2_3in = p1d & p1e & p1f;
    assign p1y = and1_3in | and2_3in;

    assign and1_2in = p2a & p2b;
    assign and2_2in = p2c & p2d;
    assign p2y = and1_2in | and2_2in;

endmodule