module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input  logic [N-1:0] a, // First N-bit fixed-point input operand
    input  logic [N-1:0] b, // Second N-bit fixed-point input operand
    output logic [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

// Internal register to store the result of the subtraction operation
logic [N-1:0] res;

// Determine the signs of the input operands
logic sign_a = a[N-1];
logic sign_b = b[N-1];

// Calculate the absolute values of the input operands
logic [N-1:0] abs_a = (sign_a)? (~a + 1) : a;
logic [N-1:0] abs_b = (sign_b)? (~b + 1) : b;

// Perform the subtraction based on the signs of the input operands
always_comb begin
    if (sign_a == sign_b) begin
        // Same sign subtraction: subtract the fractional and integer parts
        res = a - b;
    end else begin
        // Different sign subtraction: compare the absolute values and determine the sign of the result
        if (abs_a > abs_b) begin
            if (sign_a) begin
                // a is negative and larger in absolute value
                res = abs_a - abs_b;
            end else begin
                // a is positive and larger in absolute value
                res = abs_a - abs_b;
            end
        end else if (abs_a < abs_b) begin
            if (sign_a) begin
                // a is negative and smaller in absolute value
                res = abs_b - abs_a;
            end else begin
                // a is positive and smaller in absolute value
                res = abs_b - abs_a;
            end
        end else begin
            // a and b have the same absolute value
            res = 0;
        end
    end

    // Handle the edge case where the result is zero
    if (res == 0) begin
        c = {1'b0, {N-1{1'b0}}};
    end else begin
        c = res;
    end
end

endmodule