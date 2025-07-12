// Directly compute the output q using a simplified logical expression
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Compute q using a single logical expression
    assign q = (a | b) & (c | d);
    
endmodule