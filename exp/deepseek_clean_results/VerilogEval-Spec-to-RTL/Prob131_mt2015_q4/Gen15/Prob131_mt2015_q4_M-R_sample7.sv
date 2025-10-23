module TopModule(
    input x,
    input y,
    output z
);
    // Module A logic: z = (x^y) & x = x & ~y
    wire a_out = x & ~y;
    
    // Module B logic from waveform analysis: z = ~(x ^ y) (XNOR)
    wire b_out = ~(x ^ y);
    
    // Final output: XOR of the two intermediate results
    assign z = a_out ^ b_out;
endmodule