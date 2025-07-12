module TopModule (
    input in1,
    input in2,
    output out
);
    // Optimal 2-input NOR gate implementation
    // Truth table:
    // in1 in2 | out
    // ---------|---
    //  0   0  |  1
    //  0   1  |  0
    //  1   0  |  0
    //  1   1  |  0
    assign out = ~(in1 | in2);
endmodule