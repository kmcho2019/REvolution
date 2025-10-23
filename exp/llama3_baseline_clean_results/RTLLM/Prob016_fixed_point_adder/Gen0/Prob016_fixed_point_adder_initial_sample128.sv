module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32  // Total number of bits
)(
    input  wire [N-1:0] a, // First N-bit fixed-point input operand
    input  wire [N-1:0] b, // Second N-bit fixed-point input operand
    output wire [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Check if the most significant bits (MSBs) of a and b are the same
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition
        res = (a[N-1] == 1'b0) ? (a + b) : (~a + 1 + ~b + 1); // a and b are both positive or both negative
        if (res >= 2**N) begin
            // Handle overflow by saturating the result
            res = (a[N-1] == 1'b0) ? (2**N - 1) : 2**N; // Saturation for positive or negative overflow
        end
    end else begin
        // Absolute value subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
            // a is positive and b is negative
            res = a + (~b + 1); // a - (-b) = a + b
        end else begin
            // a is negative and b is positive
            res = (~a + 1) + b; // -a + b = -(a - b)
            if (res >= 2**N) begin
                // Handle overflow by saturating the result
                res = 2**N - 1; // Saturation for positive overflow
            end
        end
        // Check if result is negative and saturate if necessary
        if (res < 0) begin
            res = 0; // Saturate to zero for negative underflow
        end
    end
    c = res;
end

endmodule