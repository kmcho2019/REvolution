module TopModule (
    input in1,
    input in2,
    output out
);
    // Truth table documentation for clarity
    // in1 in2 | out
    // ---------|---
    //  0   0  | 1
    //  0   1  | 0
    //  1   0  | 0
    //  1   1  | 0
    
    // Direct NOR implementation using continuous assignment
    assign out = ~(in1 | in2);
endmodule