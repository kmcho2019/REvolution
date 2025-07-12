module TopModule (
    input in1,
    input in2,
    output out
);
    // Implement using a 2:1 mux configured as a LUT
    // Truth table for (in1 & ~in2):
    // in1 in2 | out
    // 0   0   | 0
    // 0   1   | 0
    // 1   0   | 1
    // 1   1   | 0
    assign out = in1 ? ~in2 : 1'b0;
endmodule