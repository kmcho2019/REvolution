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
    // Implement the sum-of-products logic directly
    out_sop = (b & ~a & ~c & d) | (~a & b & c & d) | (a & b & c & d);
    
    // Implement the product-of-sums logic by focusing on the conditions that result in a logic-0 output
    out_pos = (a | ~b | ~c | ~d) & (a | ~b | c | ~d) & (~a | ~b | ~c | d) & (~a | ~b | ~c | ~d) & 
              (a | b | ~c | ~d) & (a | b | ~c | d) & (~a | b | c | ~d) & (~a | b | c | d);
end

endmodule