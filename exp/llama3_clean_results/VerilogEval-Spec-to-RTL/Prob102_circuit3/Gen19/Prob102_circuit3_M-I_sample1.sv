// Define the TopModule that implements the combinational circuit
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Compute the output q directly using a single statement
    // This allows the synthesis tool to optimize the implementation
    assign q = (a | b) & (c | d);
    
endmodule