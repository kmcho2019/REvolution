module TopModule (
    input in1,
    input in2,
    output out
);
    wire in1_n, in2_n;
    
    assign in1_n = ~in1;
    assign in2_n = ~in2;
    assign out = in1_n & in2_n;
endmodule