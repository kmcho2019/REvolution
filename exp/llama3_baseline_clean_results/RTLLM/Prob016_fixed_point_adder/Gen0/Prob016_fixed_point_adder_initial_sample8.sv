module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a, // First N-bit fixed-point input operand
    input [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register to store the result

// Determine if the inputs are negative
wire a_is_negative = a[N-1];
wire b_is_negative = b[N-1];

// Absolute values of inputs (ignoring the sign bit)
wire [N-2:0] abs_a = a_is_negative? (~a[N-2:0] + 1) : a[N-2:0];
wire [N-2:0] abs_b = b_is_negative? (~b[N-2:0] + 1) : b[N-2:0];

// Perform addition or subtraction based on the signs
reg [N-1:0] result;

always @(*) begin
    if (a_is_negative == b_is_negative) begin
        // Both inputs have the same sign, add absolute values
        result = (abs_a + abs_b);
        // Set the sign bit of the result to match the inputs
        result[N-1] = a_is_negative;
    end else begin
        // Inputs have different signs, perform subtraction
        if (abs_a > abs_b) begin
            // a is larger, result is a - b, and it is positive
            result = abs_a - abs_b;
        end else begin
            // b is larger, result is b - a
            result = abs_b - abs_a;
            // Set the sign bit of the result to indicate it is negative
            result[N-1] = 1;
        end
    end
end

// Assign the calculated result to the output, handling overflow
always @(*) begin
    if (result[N-1] == 1 && result[N-2] == 1) begin
        // Overflow detected, clip the result to the maximum negative value
        c = {1'b1, {N-1{1'b0}}};
    end else if (result[N-1] == 0 && result[N-2] == 1) begin
        // Overflow detected, clip the result to the maximum positive value
        c = {1'b0, {N-1{1'b1}}};
    end else begin
        // No overflow, assign the result directly
        c = result;
    end
end

endmodule