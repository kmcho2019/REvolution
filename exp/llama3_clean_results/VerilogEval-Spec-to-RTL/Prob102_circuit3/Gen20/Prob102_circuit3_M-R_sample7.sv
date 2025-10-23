// Define the TopModule that directly computes the output q
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Directly compute the output q using the necessary logic
    assign q = (a | b) & (c | d);
    
endmodule