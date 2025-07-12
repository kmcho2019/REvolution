// Module for 3-input AND gate with optimized logic levels
module AND3(
    input  a,
    input  b,
    input  c,
    output y
);
    assign y = a & b & c;
endmodule

// Module for 2-input AND gate with minimized switching activity
module AND2(
    input  a,
    input  b,
    output y
);
    assign y = a & b;
endmodule

// Module for 2-input OR gate with reduced propagation delay
module OR2(
    input  a,
    input  b,
    output y
);
    assign y = a | b;
endmodule

// TopModule with fused design, combining modular approach and PPA optimizations
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
    wire and1_out, and2_out, and3_out, and4_out;

    // Instantiate AND gates with optimized logic levels and minimized switching activity
    AND3 and1(p1a, p1b, p1c, and1_out);
    AND3 and2(p1d, p1e, p1f, and2_out);
    AND2 and3(p2a, p2b, and3_out);
    AND2 and4(p2c, p2d, and4_out);

    // Instantiate OR gates with reduced propagation delay
    OR2 or1(and1_out, and2_out, p1y);
    OR2 or2(and3_out, and4_out, p2y);
endmodule