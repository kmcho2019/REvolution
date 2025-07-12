module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop, 
    output reg out_pos  
);

// Generate the output based on the input conditions
always @(a, b, c, d) begin
    // Implement the sum-of-products logic
    out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);
    
    // Implement the product-of-sums logic
    out_pos = ~(~a & ~b & ~c & ~d) & ~(~a & ~b & c & ~d) & ~(~a & ~b & ~c & d) &
              ~(~a & b & ~c & ~d) & ~(~a & b & c & ~d) & ~(~a & b & ~c & d) &
              ~(~a & b & c & d) & ~(a & ~b & ~c & ~d) & ~(a & ~b & c & ~d) &
              ~(a & ~b & ~c & d);
end

endmodule