// Define the simplified TopModule
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Directly compute the output q
    assign q = (a | b) & (c | d);
    
endmodule