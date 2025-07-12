module TopModule(
    input  in1,
    input  in2,
    output out
);
    
    wire in2_bar;
    
    assign in2_bar = ~in2;
    assign out = in1 ? in2_bar : 1'b0;

endmodule