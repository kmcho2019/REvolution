module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Minimum Product-of-Sums (POS) form requires consideration of all maxterms
// for 0 output conditions. Since the exact POS form isn't directly derived
// from the given conditions without K-map simplification, we'll implement
// it based on the inverse of the SOP form considering De Morgan's laws.
// However, the direct implementation of POS from the problem statement
// would involve complex maxterm combinations. For educational purposes,
// let's focus on deriving it correctly:
assign out_pos = ~( (a & ~b & ~c & ~d) | (a & ~b & ~c & d) | (a & ~b & c & ~d) | 
                  (a & ~b & c & d) | (~a & ~b & ~c & ~d) | (~a & ~b & ~c & d) | 
                  (~a & ~b & c & ~d) | (~a & b & ~c & ~d) | (~a & ~b & c & d) | 
                  (a & b & ~c & ~d) | (a & ~b & c & d) | (~a & b & c & d) | 
                  (~a & ~b & ~c & d) | (a & b & ~c & d) );

endmodule