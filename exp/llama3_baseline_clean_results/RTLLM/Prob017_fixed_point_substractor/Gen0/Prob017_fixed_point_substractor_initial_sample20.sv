module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
) (
    input  wire [N-1:0] a, // First N-bit fixed-point input operand
    input  wire [N-1:0] b, // Second N-bit fixed-point input operand
    output wire [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res; // N-bit register used to store the result of the subtraction operation

always @(*) begin
    // Calculate the sign of the inputs
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Same sign subtraction
    if (sign_a == sign_b) begin
        // Subtract the absolute values
        res = a - b;
        // Set the sign of the result to the same as the inputs
        if (res == 0) begin
            res = {1'b0, {N-1{1'b0}}}; // Handle zero result
        end else begin
            res[N-1] = sign_a;
        end
    end else begin
        // Different sign subtraction
        if (sign_a == 1'b0) begin // a is positive, b is negative
            // Add the absolute values
            res = a + (~b + 1'b1);
            // Set the sign of the result based on the relative sizes of a and b
            if (a >= b) begin
                res[N-1] = 1'b0; // Result is positive
            end else begin
                res[N-1] = 1'b1; // Result is negative
            end
        end else begin // a is negative, b is positive
            // Add the absolute values
            res = (~a + 1'b1) + b;
            // Set the sign of the result based on the relative sizes of a and b
            if (a <= b) begin
                res[N-1] = 1'b1; // Result is negative
            end else begin
                res[N-1] = 1'b0; // Result is positive
            end
        end
        // Handle zero result
        if (res == 0) begin
            res = {1'b0, {N-1{1'b0}}};
        end
    end
    // Assign the result to the output
    c = res;
end

endmodule