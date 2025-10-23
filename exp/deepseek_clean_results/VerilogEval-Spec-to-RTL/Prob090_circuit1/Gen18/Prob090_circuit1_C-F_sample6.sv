module TopModule (
    input a,
    input b,
    output q
);
    // Optimal fused implementation: direct AND with continuous assignment
    // Combines clarity of direct operation with efficiency of continuous assignment
    assign q = a & b;
endmodule