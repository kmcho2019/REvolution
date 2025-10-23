module TopModule(
    input x,
    input y,
    output z
);
    wire xor_result = x ^ y;
    wire xnor_result = ~(x ^ y);
    
    // Module A equivalent: (x^y)&x = xor_result & x
    wire a1_out = xor_result & x;
    wire a2_out = xor_result & x;
    
    // Module B equivalent: xnor_result
    wire b1_out = xnor_result;
    wire b2_out = xnor_result;
    
    // First level logic
    wire or_out = a1_out | b1_out;
    wire and_out = a2_out & b2_out;
    
    // Final output
    assign z = or_out ^ and_out;
endmodule