module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// out_sop: Sum-of-Products form
assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

// out_pos: Product-of-Sums form
assign out_pos = (~(~a & ~b & ~c & ~d) & ~(~a & ~b & ~c & d) & ~(~a & ~b & c & ~d) &
                ~(~a & b & ~c & ~d) & ~(~a & b & ~c & d) & ~(~a & b & c & ~d) &
                ~(a & ~b & ~c & d) & ~(~a & ~b & c & d) & ~(a & b & ~c & d) & ~(a & b & c & ~d));

endmodule