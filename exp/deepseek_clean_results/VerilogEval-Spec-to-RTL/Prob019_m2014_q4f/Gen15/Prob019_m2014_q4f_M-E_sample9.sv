module TopModule (
    input in1,
    input in2,
    output out
);
    wire enable = ~in2;
    assign out = enable ? in1 : 1'b0;
endmodule