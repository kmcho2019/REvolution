module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input signed [N-1:0] a, // First N-bit fixed-point input operand
    input signed [N-1:0] b, // Second N-bit fixed-point input operand
    output reg signed [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

// Internal register to store the result
reg signed [N-1:0] res;

// Determine the sign of the inputs
wire a_sign = a[N-1]; // Sign bit of a
wire b_sign = b[N-1]; // Sign bit of b

// Absolute values of a and b (without the sign bit)
wire [N-2:0] a_abs = a[N-2:0];
wire [N-2:0] b_abs = b[N-2:0];

// Compare absolute values to determine subtraction order
wire a_greater = (a_abs > b_abs) ? 1'b1 : 1'b0;

always @(*) begin
    if (a_sign == b_sign) begin // Same signs, perform addition
        res = a + b;
    end else begin // Different signs, perform subtraction
        if (a_greater) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end
end

// Assign the result to output, considering overflow
always @(*) begin
    c = res;
    // Check for overflow and adjust if necessary
    if (res > (1 << (N-1)) - 1) begin // Positive overflow
        c = (1 << (N-1)) - 1;
    end else if (res < -(1 << (N-1))) begin // Negative overflow
        c = -(1 << (N-1));
    end
end

endmodule