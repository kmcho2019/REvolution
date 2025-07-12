module TopModule (
    input  in1,    // First input (0 or 1)
    input  in2,    // Second input (0 or 1)
    output out     // NOR output (1 only when both inputs are 0)
);
    // Truth table:
    // in1 in2 | out
    // ------------
    //  0   0  |  1
    //  0   1  |  0
    //  1   0  |  0
    //  1   1  |  0
    assign out = in1 ~| in2;  // Direct NOR operator
endmodule