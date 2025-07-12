module TopModule (
    input in1,
    input in2,
    output out
);
    // Truth table:
    // in1 in2 | out
    // ---------|---
    //  0   0  | 1
    //  0   1  | 0
    //  1   0  | 0
    //  1   1  | 0
    nor(out, in1, in2);  // Most efficient NOR implementation
endmodule