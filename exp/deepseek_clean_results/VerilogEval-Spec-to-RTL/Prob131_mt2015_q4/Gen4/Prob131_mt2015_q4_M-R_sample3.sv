module TopModule(
    input x,
    input y,
    output z
);
    // Module A logic: z = (x^y) & x = x & ~y
    wire a_out = x & ~y;
    
    // Module B logic derived from truth table (behaves as XNOR)
    wire b_out = ~(x ^ y);
    
    // Final output logic: (a_out OR b_out) XOR (a_out AND b_out)
    // This simplifies to a_out XOR b_out
    assign z = a_out ^ b_out;
endmodule