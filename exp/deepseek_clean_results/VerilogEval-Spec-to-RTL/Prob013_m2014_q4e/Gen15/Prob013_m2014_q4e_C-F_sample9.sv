module TopModule (
    input in1,
    input in2,
    output out
);
    // 2-input NOR gate truth table:
    // in1 in2 | out
    //  0   0  | 1
    //  0   1  | 0
    //  1   0  | 0
    //  1   1  | 0
    assign out = ~(in1 | in2);  // NOR operation: NOT (in1 OR in2)
endmodule