module TopModule(
    input x,
    input y,
    output z
);
    wire xor_xy = x ^ y;
    wire a_out = xor_xy & x;      // ModuleA equivalent
    wire b_out = ~xor_xy;         // ModuleB equivalent
    
    // Combined logic optimized to:
    // (a_out | b_out) ^ (a_out & b_out) = a_out ^ b_out
    assign z = a_out ^ b_out;
endmodule