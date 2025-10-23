module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)
(
    input [N-1:0] a,  // First N-bit fixed-point input operand
    input [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

// Determine if the MSBs of 'a' and 'b' are the same (both positive or both negative)
wire same_sign = (a[N-1] == b[N-1]);

// Calculate absolute values of 'a' and 'b'
wire [N-1:0] abs_a = (a[N-1] == 1'b0) ? a : ~a + 1'b1;
wire [N-1:0] abs_b = (b[N-1] == 1'b0) ? b : ~b + 1'b1;

// Perform absolute value addition or subtraction based on the signs of 'a' and 'b'
always @(*) begin
    if (same_sign) begin
        // Absolute value addition
        res = abs_a + abs_b;
    end else begin
        // Absolute value subtraction
        if (abs_a > abs_b) begin
            res = abs_a - abs_b;
            // Set MSB of result to 0 (positive)
            res[N-1] = 1'b0;
        end else begin
            res = abs_b - abs_a;
            // Set MSB of result according to whether the result is zero or negative
            if (res == 0) begin
                res[N-1] = 1'b0;
            end else begin
                res[N-1] = 1'b1;
            end
        end
    end
end

// Assign result to output 'c'
assign c = res;

endmodule