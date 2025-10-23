module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
) (
    input  wire [N-1:0] a,  // First N-bit fixed-point input operand
    input  wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output reg  [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same signs, absolute value addition
        res = a + b;
        if (res >= (1 << N)) begin  // Overflow handling
            res = (1 << N) - 1;  // Saturate to maximum value
        end
    end else begin  // Different signs, absolute value subtraction
        if (a > b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
        if (res < 0) begin  // Negative result, set MSB
            res = (1 << (N-1)) + res;
        end
    end
end

always @(*) begin
    c = res;
end

endmodule