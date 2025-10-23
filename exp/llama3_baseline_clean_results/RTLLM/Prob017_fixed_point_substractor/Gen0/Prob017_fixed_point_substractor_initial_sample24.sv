module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  wire [N-1:0] a,  // First input operand
    input  wire [N-1:0] b,  // Second input operand
    output wire [N-1:0] c   // Output result
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Determine the signs of the input operands
    wire sign_a = a[N-1];  // Sign bit of operand a
    wire sign_b = b[N-1];  // Sign bit of operand b

    // Perform subtraction based on the signs of the input operands
    if (sign_a == sign_b) begin
        // Same sign subtraction: Subtract the absolute values
        if (a[N-1:Q] == 0 && a[Q-1:0] == 0 && b[N-1:Q] == 0 && b[Q-1:0] == 0) begin
            // If both operands are zero, the result is zero with a sign of 0
            res = {1'b0, {(N-1){1'b0}}};
        end else if (sign_a == 1'b0) begin
            // Both operands are positive
            res = a - b;
        end else begin
            // Both operands are negative
            res = -a - b;
        end
    end else begin
        // Different sign subtraction: Add the absolute values and determine the sign of the result
        if (a[N-1:Q] == 0 && a[Q-1:0] == 0) begin
            // Operand a is zero
            res = b;
        end else if (b[N-1:Q] == 0 && b[Q-1:0] == 0) begin
            // Operand b is zero
            res = a;
        end else if (sign_a == 1'b0 && a >= b) begin
            // Operand a is positive and greater than or equal to operand b
            res = a - b;
        end else if (sign_a == 1'b0 && a < b) begin
            // Operand a is positive and less than operand b
            res = -(b - a);
        end else if (sign_b == 1'b0 && b >= a) begin
            // Operand b is positive and greater than or equal to operand a
            res = b - a;
        end else begin
            // Operand b is positive and less than operand a
            res = -(a - b);
        end
    end

    // Explicitly set the sign bit to 0 when the result is zero
    if (res[N-1:Q] == 0 && res[Q-1:0] == 0) begin
        res[N-1] = 1'b0;
    end
end

assign c = res;

endmodule