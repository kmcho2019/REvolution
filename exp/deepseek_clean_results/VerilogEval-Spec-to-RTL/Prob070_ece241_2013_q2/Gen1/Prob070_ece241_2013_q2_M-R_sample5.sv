module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Optimized Sum-of-products
    assign out_sop = (c & d) | (~a & ~b & c & ~d);

    // Optimized Product-of-sums
    assign out_pos = (a | b) & 
                    (c | d) & 
                    (~a | ~c | ~d) & 
                    (~b | ~c | ~d);

endmodule