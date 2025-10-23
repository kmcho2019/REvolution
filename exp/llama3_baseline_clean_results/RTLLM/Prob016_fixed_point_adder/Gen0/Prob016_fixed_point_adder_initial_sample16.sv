module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16  // Total number of bits
)
(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine the signs of the operands
    if (a[N-1] == b[N-1]) begin
        // If both have the same sign, add their absolute values
        res = a + b;
        // The MSB will automatically reflect the sign of the result
    end else begin
        // If the signs are different, determine the larger absolute value
        if (a[N-1] == 1 && b[N-1] == 0) begin
            // a is negative, b is positive
            if (a < b) begin
                // b is larger, result is b - a
                res = b + (~a + 1); // Two's complement subtraction
                // If the result is negative, set MSB to 1
                if (res[N-1] == 1) begin
                    // Do nothing, MSB already set correctly
                end else begin
                    // Result is positive or zero, ensure MSB is 0
                    res[N-1] = 0;
                end
            end else begin
                // a is larger, result is a - b
                res = a + (~b + 1); // Two's complement subtraction
                // MSB is already set correctly since a is negative
            end
        end else begin
            // b is negative, a is positive
            if (a < b) begin
                // b is larger, result is b - a
                res = b + (~a + 1); // Two's complement subtraction
                // If the result is negative, set MSB to 1
                if (res[N-1] == 1) begin
                    // Do nothing, MSB already set correctly
                end else begin
                    // Result is positive or zero, ensure MSB is 0
                    res[N-1] = 0;
                end
            end else begin
                // a is larger, result is a - b
                res = a + (~b + 1); // Two's complement subtraction
                // MSB is already set correctly since a is positive
            end
        end
    end

    // Assign the result to output
    c = res;
end

endmodule