module OptimizedTopModule(
    input x,
    input y,
    output z
);
    // Shared intermediate signals
    wire a_out, b_out;
    
    // Optimized Module A implementation
    assign a_out = x & (~y);  // Equivalent to (x^y)&x
    
    // Optimized Module B implementation (direct Boolean)
    assign b_out = (x ~^ y);  // XNOR operation matches truth table
    
    // Combined logic - eliminates separate OR/AND stages
    // Original: z = (a1_out | b1_out) ^ (a2_out & b2_out)
    // Since a1=a2 and b1=b2, simplifies to:
    assign z = (a_out | b_out) ^ (a_out & b_out);
    
    // Further optimization using Boolean algebra:
    // (A+B)^(A&B) = A^B
    // Therefore final implementation could be simply:
    // assign z = a_out ^ b_out;
    // But keeping original structure for demonstration
endmodule