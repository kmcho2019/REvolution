module TopModule(
    input a, 
    input b, 
    input c, 
    input d, 
    output out_sop, 
    output out_pos
);

// Sum-of-products form for out_sop
assign out_sop = (a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Product-of-sums form for out_pos
assign out_pos = (~(~a & ~b & ~c & ~d)) & (~(~a & ~b & c & ~d)) & 
                 (~(~a & b & ~c & ~d)) & (~(~a & b & c & d)) & 
                 (~(~a & ~b & ~c & d)) & (~(~a & ~b & c & ~d)) & 
                 (~(~a & b & ~c & d)) & (~a & b & c & ~d) & 
                 (~a & ~b & c & d);

endmodule