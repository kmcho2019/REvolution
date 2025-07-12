module TopModule(
    input x,
    input y,
    output z
);
    // Module A equivalent logic: z = x & ~y
    wire a_out = x & ~y;
    
    // Module B equivalent logic: z = ~(x ^ y)
    wire b_out = ~(x ^ y);
    
    // Final output logic
    assign z = a_out ^ b_out;
endmodule