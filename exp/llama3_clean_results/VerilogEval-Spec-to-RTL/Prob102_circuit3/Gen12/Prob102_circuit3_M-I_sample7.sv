// Directly implement the required logic in a single module
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Compute the output q using the direct Boolean expression
    assign q = (a | b) & (c | d);
    
endmodule