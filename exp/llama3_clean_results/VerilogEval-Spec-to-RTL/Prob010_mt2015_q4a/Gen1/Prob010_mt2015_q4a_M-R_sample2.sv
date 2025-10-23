module TopModule(
    input x,
    input y,
    output z
);

// Intermediate signal for the XOR operation
wire xor_result;
assign xor_result = x ^ y;

// Final output z, performing AND operation with x
assign z = xor_result & x;

endmodule