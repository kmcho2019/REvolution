module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits (integer and fractional)
)(
    input  wire [N-1:0] a,  // First N-bit fixed-point input operand
    input  wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output wire [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res; // N-bit register to store the result of the subtraction operation

always @(*) begin
    // Determine the signs of the input operands
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Check if the signs are the same
    if (sign_a == sign_b) begin
        // Same sign subtraction: perform a simple subtraction operation
        if (sign_a == 1'b1) begin
            // Both numbers are negative
            res = -a - b;
        end else begin
            // Both numbers are positive
            res = a - b;
        end
    end else begin
        // Different sign subtraction: compare the absolute values
        if (a[N-2:0] > b[N-2:0]) begin
            // Result will have the same sign as 'a'
            res = a - b;
        end else if (a[N-2:0] < b[N-2:0]) begin
            // Result will have the opposite sign of 'a'
            res = - (b - a);
        end else begin
            // Absolute values are equal
            res = 0;
        end
    end

    // Handle the edge case where the result is zero
    if (res == 0) begin
        c = 0;
    end else begin
        c = res;
    end
end

endmodule