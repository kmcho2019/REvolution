module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input   wire    [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire    [N-1:0] b,  // Second N-bit fixed-point input operand
    output  reg     [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the signs of the input operands
    if (a[N-1] == b[N-1]) begin
        // Same signs, perform absolute value addition
        res = a + b;
        // If the result overflows, handle it by saturating the value
        if (res >= (1 << N)) begin
            res = (1 << N) - 1;
        end
    end else begin
        // Different signs, perform absolute value subtraction
        if (a[N-1] == 1) begin
            // a is negative, b is positive
            if (a < b) begin
                // b is larger, result is b - a and is positive
                res = b - (a + (1 << Q));
            end else begin
                // a is larger, result is a - b and is negative
                res = (a + (1 << Q)) - b;
            end
        end else begin
            // a is positive, b is negative
            if (a < b) begin
                // b is larger, result is b - a and is negative
                res = (b + (1 << Q)) - a;
            end else begin
                // a is larger, result is a - b and is positive
                res = a - (b + (1 << Q));
            end
        end
    end
    // Assign the result to the output
    c = res;
end

endmodule