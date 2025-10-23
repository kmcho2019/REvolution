module TopModule(
    input  a,
    input  b,
    output q
);
    
    assign q = a ? b : 1'b0;

endmodule