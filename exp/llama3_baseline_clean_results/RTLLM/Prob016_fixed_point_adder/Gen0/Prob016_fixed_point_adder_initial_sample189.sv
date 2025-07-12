module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input [N-1:0] a,  // First N-bit fixed-point input operand
    input [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the sign bits of the input operands `a` and `b`
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition: add the absolute values and set the MSB accordingly
        res = (a[N-1] == 1'b0) ? (a + b) : -(~(a + b) + 1'b1);
    end else begin
        // Absolute value subtraction: subtract the smaller from the larger and set the MSB accordingly
        if (a > b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end

    // Apply precision and overflow handling
    c = res[N-1:0];
end

endmodule