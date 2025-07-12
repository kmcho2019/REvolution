module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products (SOP) expression for out_sop
assign out_sop = (b & ~a & ~c & ~d) | // m2
                 (~a & b & c & d) |   // m7
                 (a & b & c & d);    // m15

// Minimum product-of-sums (POS) expression for out_pos
assign out_pos = (~(~a & ~b & ~c & ~d)) & // ~M0
                 (~(~a & ~b & ~c & d)) &   // ~M1
                 ~(a & ~b & ~c & ~d) &    // ~M4
                 ~(a & ~b & ~c & d) &     // ~M5
                 ~(a & ~b & c & ~d) &     // ~M6
                 ~(~a & b & ~c & d) &     // ~M9
                 ~(~a & b & c & ~d) &     // ~M10
                 ~(a & ~b & c & d) &      // ~M13
                 ~(a & b & ~c & ~d);      // ~M14

endmodule