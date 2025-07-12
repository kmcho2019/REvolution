module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form
assign out_sop = (b & ~a & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Minimum Product-of-Sums (POS) form, considering De Morgan's laws
// First, find the sums for each maxterm that should be 0, then apply AND between them
assign out_pos = ~( (~a & ~b & ~c & ~d) | (~a & ~b & ~c & d) | (~a & ~b & c & ~d) | (~a & ~b & c & d) |
                   (~a & b & ~c & ~d) | (~a & b & ~c & d) | (~a & b & c & ~d) | 
                   (a & ~b & ~c & d) | (a & ~b & c & ~d) | (a & b & ~c & d) | (a & ~b & c & d) );

endmodule