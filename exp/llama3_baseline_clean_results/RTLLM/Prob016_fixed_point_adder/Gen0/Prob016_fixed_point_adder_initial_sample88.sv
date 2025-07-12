module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16 // Total number of bits, including integer and fractional parts
)(
    input  [N-1:0] a, // First N-bit fixed-point input operand
    input  [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the sign of the input operands
    reg a_sign = a[N-1];
    reg b_sign = b[N-1];

    // Perform absolute value addition or subtraction based on the signs of the input operands
    if (a_sign == b_sign) begin
        // Absolute value addition
        res = a + b;
        // The MSB of the result is set to match the MSBs of a and b (sign bit remains consistent)
        if (res[N-1] != a_sign) begin
            // Handle overflow
            if (a_sign == 1'b1) begin
                // Overflow in negative numbers
                res = {N{1'b1}};
            end else begin
                // Overflow in positive numbers
                res = {1'b0, {N-1{1'b1}}};
            end
        end
    end else begin
        // Absolute value subtraction
        if (a > b) begin
            // a is greater than b
            res = a - b;
            // The MSB of the result is set to 0 (positive)
            if (res[N-1] == 1'b1) begin
                // Handle overflow
                res = {N{1'b0}};
            end
        end else if (a < b) begin
            // b is greater than a
            res = b - a;
            // The MSB of the result is set according to whether the result is zero or negative
            if (res == {N{1'b0}}) begin
                // Result is zero
                res = {N{1'b0}};
            end else begin
                // Result is negative
                res = {1'b1, {N-1{1'b0}}};
            end
        end else begin
            // a and b are equal
            res = {N{1'b0}};
        end
    end
end

assign c = res;

endmodule