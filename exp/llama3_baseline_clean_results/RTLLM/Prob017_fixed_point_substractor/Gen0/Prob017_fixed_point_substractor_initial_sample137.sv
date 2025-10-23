module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    // Determine the signs of the inputs
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];

    // Perform subtraction based on the signs of the inputs
    if (sign_a == sign_b) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (sign_a == 1'b0 && sign_b == 1'b1) begin
            // a is positive, b is negative
            res = a + (~b + 1'b1);
        end else begin
            // a is negative, b is positive
            res = (~a + 1'b1) + b;
        end
    end

    // Handle the case where the result is zero
    if (res == 0) begin
        res[N-1] = 1'b0; // Explicitly set the sign bit to 0
    end

    // Assign the result to the output
    c = res;
end

endmodule