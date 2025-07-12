module TopModule(
    input  [3:0] in,  // 4-bit input vector
    output reg out_and,  // 1-bit output for AND operation
    output reg out_or,   // 1-bit output for OR operation
    output reg out_xor   // 1-bit output for XOR operation
);

always @(*) begin
    out_and = &in;  // Using reduction AND operator
    out_or  = |in;  // Using reduction OR operator
    out_xor = ^in;  // Using reduction XOR operator
end

endmodule