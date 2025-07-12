module TopModule (
    input x,
    input y,
    output z
);
    wire xor_result;
    assign xor_result = x ^ y;
    assign z = xor_result & x;
endmodule