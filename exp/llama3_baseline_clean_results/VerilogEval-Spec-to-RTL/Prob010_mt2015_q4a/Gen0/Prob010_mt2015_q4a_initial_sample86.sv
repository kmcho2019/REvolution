module TopModule(
    input x,
    input y,
    output z
);

// Calculate XOR of x and y
wire xor_result = x ^ y;

// AND the XOR result with x
assign z = xor_result & x;

endmodule