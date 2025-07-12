module TopModule(
    input [3:0] x,
    output logic f
);
    
    logic term1, term2;
    
    assign term1 = x[3] & (x[1] | x[2]);
    assign term2 = x[0] & x[1] & x[2];
    
    assign f = term1 | term2;

endmodule