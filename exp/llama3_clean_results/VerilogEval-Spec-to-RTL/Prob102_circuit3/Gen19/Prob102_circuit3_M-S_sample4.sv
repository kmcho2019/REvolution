// Top-level module implementing the combinational circuit
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Directly assign the result of the combined OR and AND operations to output q
    assign q = (a | b) & (c | d);
    
endmodule