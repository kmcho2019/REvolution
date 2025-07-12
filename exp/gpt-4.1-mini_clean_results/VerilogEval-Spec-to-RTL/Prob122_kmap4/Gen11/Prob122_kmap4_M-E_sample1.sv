module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // XNOR gate for (a,c): xnor_ac = a XNOR c = (a & c) | (~a & ~c)
    wire not_a, not_c;
    wire and1_ac, and2_ac;
    wire xnor_ac;

    assign not_a = ~a;
    assign not_c = ~c;
    assign and1_ac = a & c;
    assign and2_ac = not_a & not_c;
    assign xnor_ac = and1_ac | and2_ac;

    // XNOR gate for (b,d): xnor_bd = b XNOR d = (b & d) | (~b & ~d)
    wire not_b, not_d;
    wire and1_bd, and2_bd;
    wire xnor_bd;

    assign not_b = ~b;
    assign not_d = ~d;
    assign and1_bd = b & d;
    assign and2_bd = not_b & not_d;
    assign xnor_bd = and1_bd | and2_bd;

    // XOR gate for xnor_ac and xnor_bd: out = xnor_ac XOR xnor_bd
    // XOR = (A & ~B) | (~A & B)
    wire not_xnor_ac, not_xnor_bd;
    wire and1_out, and2_out;

    assign not_xnor_ac = ~xnor_ac;
    assign not_xnor_bd = ~xnor_bd;
    assign and1_out = xnor_ac & not_xnor_bd;
    assign and2_out = not_xnor_ac & xnor_bd;
    assign out = and1_out | and2_out;

endmodule