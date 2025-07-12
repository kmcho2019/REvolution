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
    assign out = ~(in1 | in2);  // NOR implemented as NOT of OR
endmodule