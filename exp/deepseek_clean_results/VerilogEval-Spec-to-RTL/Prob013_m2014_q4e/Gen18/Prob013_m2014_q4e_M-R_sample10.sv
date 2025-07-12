module TopModule (
    input in1,
    input in2,
    output out
);
    // Truth table remains identical:
    // in1 in2 | out
    // ---------|---
    //  0   0  | 1
    //  0   1  | 0
    //  1   0  | 0
    //  1   1  | 0
    
    wire or_out;  // Intermediate signal
    
    // First implement OR operation
    assign or_out = in1 | in2;
    
    // Then invert to get NOR
    assign out = ~or_out;
endmodule