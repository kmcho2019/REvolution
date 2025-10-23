module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32  // Total number of bits, including integer and fractional parts
) (
    input  [N-1:0] a, // First N-bit fixed-point input operand
    input  [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the signs of inputs a and b
    reg a_sign, b_sign;
    assign a_sign = a[N-1];
    assign b_sign = b[N-1];

    // Perform absolute value addition or subtraction based on the signs
    if (a_sign == b_sign) begin
        // Absolute value addition
        res = a + b;
    end else begin
        // Absolute value subtraction
        if (a > b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end

    // Handle overflow by checking the MSB of the result
    if (res[N-1]!= a_sign && res[N-1]!= b_sign) begin
        // Overflow occurred, clamp the result to the maximum or minimum value
        if (res[N-1] == 1) begin
            res = {N{1'b1}};
        end else begin
            res = {N{1'b0}};
        end
    end

    // Assign the result to the output
    c = res;
end

endmodule