module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits (integer + fractional)
)
(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;

always @(a or b) begin
    // Determine the signs of the inputs
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Perform subtraction or addition based on the signs of the inputs
    if (sign_a == sign_b) begin
        // Same sign subtraction
        res = a - b;
    end else if (sign_a == 1'b0 && sign_b == 1'b1) begin
        // a is positive, b is negative
        res = a + (~b + 1'b1);
    end else begin
        // a is negative, b is positive
        res = (~a + 1'b1) + b;
    end

    // Handle the edge case where the result is zero
    if (res == 0) begin
        res[N-1] = 1'b0;  // Set the sign bit to 0
    end
end

// Assign the result to the output
assign c = res;

endmodule