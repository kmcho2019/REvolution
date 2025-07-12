module TopModule (
    input in1,
    input in2,
    output out
);
    // Combined inversion and AND operation
    assign out = in1 & ~in2;
endmodule