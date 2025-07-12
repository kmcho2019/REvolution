module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input  [N-1:0] a, // First N-bit fixed-point input operand
    input  [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    if (a[N-1] == b[N-1]) begin // MSBs of `a` and `b` are the same
        // Absolute value addition
        res = a + b;
        if (res >= (1 << N)) begin // Overflow handling
            res = (1 << N) - 1;
        end
    end else begin // MSBs of `a` and `b` are different
        // Absolute value subtraction
        if (a >= b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
        if (res < 0) begin // Result is negative
            res = -res;
            res[N-1] = 1; // Set MSB to 1 for negative result
        end else begin
            res[N-1] = 0; // Set MSB to 0 for non-negative result
        end
    end
end

assign c = res;

endmodule