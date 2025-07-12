module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)
(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign, add absolute values
        res = a + b;
        if (res >= (1 << N)) begin  // Overflow, adjust result
            res = (1 << N) - 1;
        end
    end else begin  // Different signs, subtract absolute values
        if (a >= b) begin
            res = a - b;
        end else begin
            res = b - a;
            if (res != 0) begin  // Result is negative
                res = -(res);
            end
        end
    end
    c = res;
end

endmodule