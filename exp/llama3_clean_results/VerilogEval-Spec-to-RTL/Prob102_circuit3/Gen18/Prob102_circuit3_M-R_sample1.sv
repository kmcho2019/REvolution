// Define the TopModule that directly computes the output q
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Compute the output q directly using the inputs
    assign q = (a | b) & (c | d);
    
endmodule