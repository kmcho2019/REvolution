module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Optimized Sum-of-products implementation for out_sop
    // out_sop = cd + a'b'cd' (covers 2,3,7,11,15)
    assign out_sop = (c & d) | (~a & ~b & c & ~d);

    // Corrected Product-of-sums implementation for out_pos
    // out_pos = (a+b)(c+d)(a'+c'+d')
    assign out_pos = (a | b) & 
                     (c | d) & 
                     (~a | ~c | ~d);

endmodule