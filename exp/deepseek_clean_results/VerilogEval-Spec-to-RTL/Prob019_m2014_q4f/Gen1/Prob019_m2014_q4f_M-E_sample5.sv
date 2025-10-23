module TopModule (
    input in1,
    input in2,
    output out
);
    // Implement as a 2-input LUT using a multiplexer
    // Truth table:
    // in1 in2 | out
    //  0   0  |  0
    //  0   1  |  0
    //  1   0  |  1
    //  1   1  |  0
    
    assign out = (in1 & ~in2) ? 1'b1 : 1'b0;
endmodule