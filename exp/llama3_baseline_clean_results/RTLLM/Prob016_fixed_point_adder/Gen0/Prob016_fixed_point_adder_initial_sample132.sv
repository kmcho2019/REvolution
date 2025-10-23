module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Check if the most significant bits (MSBs) of a and b are the same
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition
        res = a + b;
        // The MSB of the result is set to match the MSBs of a and b (sign bit remains consistent)
        c = res;
    end else begin
        // Absolute value subtraction
        if (a >= b) begin
            // If a is greater than b, the result is a - b and the MSB of the result is set to 0 (positive)
            res = a - b;
            c = res;
        end else begin
            // If b is greater than a, the result is b - a
            res = b - a;
            // The MSB of the result is set according to whether the result is zero or negative
            if (res == 0) begin
                c = res;
            end else begin
                c = {1'b1, res[N-2:0]};
            end
        end
    end
end

endmodule