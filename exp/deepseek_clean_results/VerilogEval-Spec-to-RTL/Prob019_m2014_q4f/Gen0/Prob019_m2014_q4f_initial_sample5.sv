module TopModule (
    input in1,
    input in2,
    output out
);
    wire in2_inverted;
    
    assign in2_inverted = ~in2;
    assign out = in1 & in2_inverted;
endmodule