module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16 // Total number of bits, including integer and fractional parts
)(
    input [N-1:0] a, // First N-bit fixed-point input operand
    input [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the operation (addition or subtraction) based on the signs of the input operands
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition
        res = (a + b);
        // Ensure the MSB of the result is consistent with the MSBs of a and b
        if (a[N-1] == 1'b1) begin
            if (res >= (1 << (N-1))) begin
                // Overflow handling for negative numbers
                res = (1 << (N-1)) - 1;
            end
        end else begin
            if (res >= (1 << (N-1))) begin
                // Overflow handling for positive numbers
                res = (1 << (N-1)) - 1;
            end
        end
    end else begin
        // Absolute value subtraction
        if (a >= b) begin
            // a is greater than b
            res = a - b;
            // Ensure the MSB of the result is 0 (positive)
            if (res >= (1 << (N-1))) begin
                // Overflow handling for positive numbers
                res = (1 << (N-1)) - 1;
            end
        end else begin
            // b is greater than a
            res = b - a;
            // Ensure the MSB of the result is consistent with the sign of the result
            if (res >= (1 << (N-1))) begin
                // Overflow handling for negative numbers
                res = (1 << (N-1)) - 1;
            end else if (res == 0) begin
                // If the result is zero, set the MSB to 0
                res = 0;
            end else begin
                // If the result is negative, set the MSB to 1
                res = -res;
            end
        end
    end
end

assign c = res;

endmodule