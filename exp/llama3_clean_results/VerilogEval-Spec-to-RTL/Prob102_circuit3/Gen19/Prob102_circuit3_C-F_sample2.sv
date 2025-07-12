// Define the TopModule that combines the logic and computes the output q
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Compute the output q using the results of the OR gates
    assign q = (a | b) & (c | d);
    
endmodule