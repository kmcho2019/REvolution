module TopModule (
    input  a, b, c, d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation (minimized form)
    assign out_sop = (b & c & ~d) | (~a & c & d) | (a & b & c);

    // Product-of-sums implementation (minimized form)
    assign out_pos = (b | d) & (~a | c | d) & (a | ~b | ~d);

endmodule