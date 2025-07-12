module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
) (
    input   wire [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output  wire [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    // Determine the signs of the input operands
    wire signed_a = a[N-1]; // Sign bit of operand 'a'
    wire signed_b = b[N-1]; // Sign bit of operand 'b'

    // Perform subtraction based on the signs
    if (signed_a == signed_b) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (~signed_a && signed_b) begin
            // a is positive, b is negative
            if (a > -b) begin
                res = a + (~b + 1); // Add absolute values and set sign
            end else begin
                res = (~a + 1) + b; // Add absolute values and set sign
                res = ~res + 1; // Two's complement for negative result
            end
        end else if (signed_a && ~signed_b) begin
            // a is negative, b is positive
            if (-a > b) begin
                res = (~a + 1) + (~b + 1); // Add absolute values and set sign
                res = ~res + 1; // Two's complement for negative result
            end else begin
                res = a + (~b + 1); // Add absolute values and set sign
            end
        end
    end

    // Handle zero result explicitly
    if (res == 0) begin
        res[N-1] = 0; // Set sign bit to 0 for zero result
    end
end

// Assign the result to output port
assign c = res;

endmodule