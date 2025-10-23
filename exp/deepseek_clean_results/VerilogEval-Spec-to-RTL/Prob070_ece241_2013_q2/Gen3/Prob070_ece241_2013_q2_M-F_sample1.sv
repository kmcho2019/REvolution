module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Correct Sum-of-products implementation
    assign out_sop = (c & d) | (~a & ~b & c & ~d);

    // Corrected Product-of-sums implementation
    assign out_pos = (a | b) & 
                     (~a | c) & 
                     (~b | c | d) & 
                     (~b | ~c | ~d);

endmodule