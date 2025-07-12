// Top-level module implementing the optimized combinational circuit
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Directly compute the output q using a single assignment statement
    assign q = (a | b) & (c | d);
    
endmodule