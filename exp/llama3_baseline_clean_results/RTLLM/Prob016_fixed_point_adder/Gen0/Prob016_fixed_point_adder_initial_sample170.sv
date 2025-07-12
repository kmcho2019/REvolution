module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
) (
    input   [N-1:0] a, // First N-bit fixed-point input operand
    input   [N-1:0] b, // Second N-bit fixed-point input operand
    output  [N-1:0] c  // N-bit output representing the result
);

reg [N-1:0] res; // Internal register to store the result

always @(a, b) begin
    // Check if the MSBs of a and b are the same (both positive or both negative)
    if (a[N-1] == b[N-1]) begin
        // Add the absolute values of a and b
        res = a + b;
    end else begin
        // Determine the larger absolute value
        if (a[N-1] == 1) begin // a is negative
            if (b[N-1] == 0) begin // b is positive
                if (a < b) begin
                    // b - a, with result being positive
                    res = b + (~a + 1);
                    res[N-1] = 0; // Ensure MSB is 0 for positive result
                end else begin
                    // a - b, with result being negative
                    res = a + (~b + 1);
                    res[N-1] = 1; // Ensure MSB is 1 for negative result
                end
            end
        end else begin // a is positive
            if (b[N-1] == 1) begin // b is negative
                if (a < b) begin
                    // b - a, with result being negative
                    res = b + (~a + 1);
                    res[N-1] = 1; // Ensure MSB is 1 for negative result
                end else begin
                    // a - b, with result being positive
                    res = a + (~b + 1);
                    res[N-1] = 0; // Ensure MSB is 0 for positive result
                end
            end
        end
    end
end

assign c = res; // Assign the result to output port c

endmodule