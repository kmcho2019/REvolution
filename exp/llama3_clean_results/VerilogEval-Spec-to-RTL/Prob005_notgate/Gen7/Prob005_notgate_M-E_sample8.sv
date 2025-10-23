module TopModule(
    input  in,
    output out
);
    
    wire inverse_in;
    assign inverse_in = ~in;
    
    assign out = (1'b0) ? in : inverse_in;
    
endmodule