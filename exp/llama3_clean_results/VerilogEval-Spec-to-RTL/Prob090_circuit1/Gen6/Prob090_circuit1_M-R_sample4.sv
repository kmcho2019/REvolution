module TopModule(
    input  a,
    input  b,
    output q
);
    
always @(*)
    q = a & b;

endmodule