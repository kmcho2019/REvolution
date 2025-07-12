module TopModule (
    input in1,
    input in2,
    output out
);
    wire in2_n;
    assign in2_n = ~in2;
    assign out = in1 & in2_n;
endmodule