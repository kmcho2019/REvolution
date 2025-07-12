// Top-level module implementing the combinational circuit
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Directly compute the output q using the simplified logic equation
    assign q = (a | b) & (c | d);
    
endmodule