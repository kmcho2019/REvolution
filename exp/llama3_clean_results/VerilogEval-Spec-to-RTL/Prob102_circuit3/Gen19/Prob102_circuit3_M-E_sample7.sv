// Define the TopModule that directly computes the output q
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Directly assign the result of the simplified Boolean expression to output q
    assign q = (a | b) & (c | d);
    
endmodule