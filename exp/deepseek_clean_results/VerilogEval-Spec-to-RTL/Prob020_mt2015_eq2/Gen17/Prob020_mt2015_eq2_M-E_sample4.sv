module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    wire b0_sel, b1_sel;
    wire b0_eq, b1_eq;
    
    // MUX-based bit comparison
    // For each bit: if A=1, pass B; if A=0, pass ~B
    assign b0_sel = A[0] ? B[0] : ~B[0];
    assign b1_sel = A[1] ? B[1] : ~B[1];
    
    // The selected bits should both be 1 for equality
    assign b0_eq = b0_sel;
    assign b1_eq = b1_sel;
    
    // Final output is 1 only if all bits match
    assign z = b0_eq & b1_eq;
endmodule