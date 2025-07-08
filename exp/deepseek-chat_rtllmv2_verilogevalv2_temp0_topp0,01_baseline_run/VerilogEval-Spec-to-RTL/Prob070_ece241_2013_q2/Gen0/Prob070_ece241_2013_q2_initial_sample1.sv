module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation
    assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

    // Product-of-sums implementation
    assign out_pos = (a | b | c | d) & 
                     (a | b | c | ~d) & 
                     (a | ~b | c | d) & 
                     (a | ~b | c | ~d) & 
                     (a | ~b | ~c | d) & 
                     (~a | b | c | ~d) & 
                     (~a | b | ~c | d) & 
                     (~a | ~b | c | d) & 
                     (~a | ~b | c | ~d);

endmodule