module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Internal signals
wire a_sign = a[N-1];
wire b_sign = b[N-1];
wire [N-2:0] a_mag = a[N-2:0];
wire [N-2:0] b_mag = b[N-2:0];
wire same_sign = (a_sign == b_sign);

always @(*) begin
    if (same_sign) begin
        // Same sign subtraction
        c = a - b;
    end
    else begin
        // Different sign addition
        c = a - b;  // Equivalent to a + (-b)
    end

    // Explicit zero handling
    if (c == 0)
        c[N-1] = 0;
end

endmodule