module TopModule (
    input x,
    input y,
    output z
);
    wire xor_result;
    
    assign xor_result = x ^ y;  // XOR operation
    assign z = xor_result & x;  // AND with x
endmodule