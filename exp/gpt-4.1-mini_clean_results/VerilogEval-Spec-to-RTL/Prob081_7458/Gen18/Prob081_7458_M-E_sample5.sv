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
    wire and1_out, and2_out, and3_out, and4_out;

    // Four AND gates
    and and1(and1_out, p1a, p1b, p1c);
    and and2(and2_out, p1d, p1e, p1f);
    and and3(and3_out, p2a, p2b);
    and and4(and4_out, p2c, p2d);

    // Two OR gates
    or  or1(p1y, and1_out, and2_out);
    or  or2(p2y, and3_out, and4_out);

endmodule