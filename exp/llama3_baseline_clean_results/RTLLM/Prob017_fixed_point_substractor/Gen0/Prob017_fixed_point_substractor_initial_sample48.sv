module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register used to store the result of the subtraction operation

// Determine the sign of the inputs
wire a_sign = a[N-1];  // Sign of input a
wire b_sign = b[N-1];  // Sign of input b

// Perform subtraction or addition based on the signs of the inputs
always @(*) begin
    if (a_sign == b_sign) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (a_sign == 1'b0) begin
            // a is positive, b is negative
            if (a > ~b + 1) begin
                // a is greater than b
                res = a + ~b + 1;
            end else begin
                // b is greater than a
                res = (~a + 1) + b;
                res[N-1] = 1'b1;  // Set sign bit to 1 (negative)
            end
        end else begin
            // a is negative, b is positive
            if (~a + 1 > b) begin
                // a is greater than b
                res = (~a + 1) + ~b + 1;
                res[N-1] = 1'b1;  // Set sign bit to 1 (negative)
            end else begin
                // b is greater than a
                res = a + ~b + 1;
            end
        end
    end

    // Handle zero result
    if (res == 0) begin
        res[N-1] = 1'b0;  // Set sign bit to 0 (positive)
    end
end

assign c = res;

endmodule