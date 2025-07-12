module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Mux implementation of K-map
    assign out = (~a & ~b) ? (c ^ d) :
                 (~a &  b) ? ~(c ^ d) :
                 ( a &  b) ? (c ^ d) :
                 /* a & ~b */ ~(c ^ d);

endmodule