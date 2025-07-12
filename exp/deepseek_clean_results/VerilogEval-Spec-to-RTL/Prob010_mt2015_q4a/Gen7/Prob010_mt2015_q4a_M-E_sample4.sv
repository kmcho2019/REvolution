module TopModule (
    input x,
    input y,
    output z
);
    wire xor_result;
    
    // XOR gate for x^y
    assign xor_result = x ^ y;
    
    // AND gate for (x^y) & x
    assign z = xor_result & x;
endmodule