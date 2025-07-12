module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

// Assign out_sop directly from the SOP expression
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Implement out_pos using the product-of-sums form directly
assign out_pos = ~( (a & ~b & ~c & ~d) | (~a & ~b & ~c & d) | (~a & ~b & c & ~d) | (~a & ~b & c & d) | (~a & b & ~c & ~d) | (~a & ~b & ~c & ~d) | (a & ~b & ~c & ~d) | (a & ~b & ~c & d) | (a & ~b & d & ~c) | (~a & ~b & d & ~c) );

endmodule