module TopModule(
    input x,
    input y,
    output z
);
    // Compute Module A function directly
    wire a_out = (x ^ y) & x;
    
    // Implement Module B as direct lookup (matches waveform behavior)
    wire b_out = (x & y) | (~x & ~y);
    
    // First level logic - share b_out between both paths
    wire or_out = a_out | b_out;
    wire and_out = a_out & b_out;
    
    // Final output
    assign z = or_out ^ and_out;
endmodule