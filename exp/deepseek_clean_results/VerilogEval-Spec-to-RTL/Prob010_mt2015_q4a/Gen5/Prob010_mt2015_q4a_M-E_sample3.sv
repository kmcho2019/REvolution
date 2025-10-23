module TopModule (
    input x,
    input y,
    output z
);
    // MUX-based implementation of z = (x^y) & x
    wire xor_result;
    wire mux_out;
    
    assign xor_result = x ^ y;
    assign mux_out = xor_result ? x : 1'b0;
    assign z = mux_out & x;  // This AND is redundant but maintains the original function
    
    // Note: This could be further optimized to just assign z = x & ~y,
    // but we keep the mux structure to demonstrate the alternative approach
endmodule