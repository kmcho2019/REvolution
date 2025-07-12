module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input   wire [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output  wire [N-1:0] c   // N-bit output representing the result
);

reg [N-1:0] res;  // N-bit register to store the result

always @(*) begin
    // Determine the sign bits of the input operands
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Perform same-sign subtraction
    if (sign_a == sign_b) begin
        // Subtract the absolute values
        res = (sign_a == 1'b0) ? (a - b) : -(a - b);
    end
    // Perform different-sign subtraction (addition with sign adjustment)
    else begin
        // Add the absolute values and adjust the sign based on the relative sizes
        if (a[N-1:Q] >= b[N-1:Q]) begin
            res = (a + (~b + 1'b1));
        end else begin
            res = -((~a + 1'b1) + b);
        end
    end

    // Handle the zero result case
    if (res == 0) begin
        res[N-1] = 1'b0;  // Explicitly set the sign bit to 0 for zero result
    end
end

assign c = res;

endmodule