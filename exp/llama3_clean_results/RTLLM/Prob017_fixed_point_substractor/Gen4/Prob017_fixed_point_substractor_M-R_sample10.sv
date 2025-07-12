module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Determine the signs of the inputs
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Preprocessing stage: Determine the absolute values
wire signed [N-1:0] abs_a;
wire signed [N-1:0] abs_b;

assign abs_a = (sign_a) ? -a : a;  // Simplified absolute value calculation
assign abs_b = (sign_b) ? -b : b;  // Simplified absolute value calculation

// Core computation stage
always @(*) begin
    if (sign_a == sign_b) begin
        // Same sign subtraction
        c = a - b;
    end else begin
        // Different sign subtraction
        c = (abs_a > abs_b) ? (abs_a - abs_b) : -(abs_b - abs_a);
    end
end

endmodule