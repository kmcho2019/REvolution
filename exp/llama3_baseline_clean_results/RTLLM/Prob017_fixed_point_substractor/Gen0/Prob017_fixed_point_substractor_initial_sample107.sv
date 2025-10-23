module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Determine the signs of the inputs
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];

    // Calculate the absolute values of the inputs
    reg [N-1:0] abs_a = (sign_a) ? (~a + 1) : a;
    reg [N-1:0] abs_b = (sign_b) ? (~b + 1) : b;

    // Perform subtraction or addition based on the signs
    if (sign_a == sign_b) begin
        // Same sign subtraction
        res = (sign_a) ? (~a + 1) - (~b + 1) : a - b;
    end else if (~sign_a & sign_b) begin
        // a is positive, b is negative
        res = a + (~b + 1);
    end else begin
        // a is negative, b is positive
        res = (~a + 1) + b;
    end

    // Handle zero result
    if (res == 0) begin
        c[N-1] = 0;  // Set sign bit to 0
        c[N-2:0] = 0;  // Set all other bits to 0
    end else begin
        // Determine the sign of the result
        c[N-1] = (res[N-1]) ? 1 : 0;
        c[N-2:0] = res[N-2:0];
    end
end

endmodule