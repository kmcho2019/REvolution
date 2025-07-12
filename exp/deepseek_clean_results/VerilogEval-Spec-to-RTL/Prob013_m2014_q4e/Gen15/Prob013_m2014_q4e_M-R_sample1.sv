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
    
    wire or_out;
    
    // First do OR operation
    assign or_out = in1 | in2;
    
    // Then invert for NOR
    assign out = ~or_out;
endmodule