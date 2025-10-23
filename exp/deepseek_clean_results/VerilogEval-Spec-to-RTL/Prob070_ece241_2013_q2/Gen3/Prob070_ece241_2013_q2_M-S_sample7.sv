module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation (minimized form)
    assign out_sop = c & ((~a & ~b & ~d) | (b & d));

    // Product-of-sums implementation (minimized form)
    assign out_pos = ~(~c | (a & b & ~d) | (~b & d) | (b & ~d));

endmodule