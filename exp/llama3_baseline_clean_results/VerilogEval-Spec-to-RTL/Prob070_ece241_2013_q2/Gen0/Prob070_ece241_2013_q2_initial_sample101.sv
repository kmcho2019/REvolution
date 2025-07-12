module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) implementation
assign out_sop = (b & ~c & d) | (c & d);

// Minimum Product-of-Sums (POS) implementation
assign out_pos = ~( (~a & ~b & ~c & ~d) | (~a & ~b & ~c & d) | (~a & ~b & c & ~d) | 
                   (~a & ~b & c & d) | (~a & b & ~c & ~d) | (a & ~b & ~c & d) | 
                   (a & ~b & c & ~d) | (a & b & ~c & ~d) | (a & b & c & ~d) );

endmodule