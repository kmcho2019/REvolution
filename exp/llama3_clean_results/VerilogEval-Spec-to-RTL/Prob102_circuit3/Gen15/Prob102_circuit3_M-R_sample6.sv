// Define the TopModule that computes the output q
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Compute the output q using a single assign statement
    assign q = (a | b) & (c | d);
    
endmodule