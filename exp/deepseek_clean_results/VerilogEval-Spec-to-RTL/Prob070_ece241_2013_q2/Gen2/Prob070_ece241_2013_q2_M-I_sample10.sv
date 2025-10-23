module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation (minimized form)
    assign out_sop = (~a & c & ~d) | (b & c & d);

    // Product-of-sums implementation (minimized form)
    assign out_pos = (a | b | c) & (a | c | d) & (~a | b | ~c | ~d);

endmodule