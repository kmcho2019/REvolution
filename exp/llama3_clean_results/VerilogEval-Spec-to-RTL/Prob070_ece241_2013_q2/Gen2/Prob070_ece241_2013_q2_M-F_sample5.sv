module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Direct implementation of sum-of-products for out_sop
assign out_sop = (!a & b & !c & d) | (!a & b & c & d) | (a & b & c & d);

// Direct implementation of product-of-sums for out_pos
assign out_pos = !( (!a & !b & !c & !d) | 
                   (!a & !b & !c & d) | 
                   (!a & !b & c & !d) | 
                   (!a & !b & c & d) | 
                   (!a & b & !c & !d) | 
                   (!a & b & !c & d) | 
                   (!a & b & c & !d) | 
                   (a & !b & !c & !d) | 
                   (a & !b & !c & d) );

endmodule