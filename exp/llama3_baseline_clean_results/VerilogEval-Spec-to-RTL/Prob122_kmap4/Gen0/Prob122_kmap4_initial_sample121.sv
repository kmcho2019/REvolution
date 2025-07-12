module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

    assign out = ((~a & ~b & ~c & ~d) ? 0 :
                 (a & ~b & ~c & ~d) ? 1 :
                 (~a & b & ~c & ~d) ? 1 :
                 (a & b & ~c & ~d) ? 0 :
                 (~a & ~b & c & ~d) ? 1 :
                 (a & ~b & c & ~d) ? 0 :
                 (~a & b & c & ~d) ? 1 :
                 (a & b & c & ~d) ? 1 :
                 (~a & ~b & ~c & d) ? 1 :
                 (a & ~b & ~c & d) ? 0 :
                 (~a & b & ~c & d) ? 1 :
                 (a & b & ~c & d) ? 0 :
                 (~a & ~b & c & d) ? 1 :
                 (a & ~b & c & d) ? 0 :
                 (~a & b & c & d) ? 1 :
                 (a & b & c & d) ? 0 : 0);

endmodule