module TopModule (
    input in1,
    input in2,
    output out
);
    // Equivalent to: when in2 is 0, pass in1; else output 0
    assign out = in1 & ~in2;
endmodule