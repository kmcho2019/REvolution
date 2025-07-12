module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

// Determine the signs of the input operands
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Calculate the absolute values of the input operands
wire [N-1:0] abs_a = (sign_a == 1'b0) ? a : (~a + 1'b1);
wire [N-1:0] abs_b = (sign_b == 1'b0) ? b : (~b + 1'b1);

// Check if the input operands have the same sign
wire same_sign = (sign_a == sign_b);

// Perform addition if the input operands have the same sign
wire [N-1:0] add_result = abs_a + abs_b;

// Perform subtraction if the input operands have different signs
wire [N:0] sub_result_a = abs_a - abs_b;
wire [N:0] sub_result_b = abs_b - abs_a;

// Determine the larger absolute value
wire larger_abs_a = (abs_a > abs_b);
wire larger_abs_b = (abs_b > abs_a);

// Assign the result of the operation
always @(*) begin
    if (same_sign) begin
        // If the input operands have the same sign, add their absolute values
        res = add_result;
        // Set the sign of the result to match the signs of the input operands
        if (sign_a == 1'b1) begin
            if (add_result[N-1] == 1'b0) begin
                res = {1'b1, {N-1{1'b1}}};
            end else begin
                res = add_result;
            end
        end else begin
            res = add_result;
        end
    end else begin
        // If the input operands have different signs, perform subtraction
        if (larger_abs_a) begin
            // If 'a' has the larger absolute value, subtract 'b' from 'a'
            res = sub_result_a[N-1:0];
            // Set the sign of the result to 0 (positive)
            if (res[N-1] == 1'b1) begin
                res = {1'b0, {N-1{1'b1}}};
            end else begin
                res = sub_result_a[N-1:0];
            end
        end else begin
            // If 'b' has the larger absolute value, subtract 'a' from 'b'
            res = sub_result_b[N-1:0];
            // Set the sign of the result according to whether the result is zero or negative
            if (res[N-1] == 1'b1) begin
                res = sub_result_b[N-1:0];
            end else begin
                res = sub_result_b[N-1:0];
            end
        end
    end
end

// Assign the result to the output port
assign c = res;

endmodule