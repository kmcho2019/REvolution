module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Signals for sign and magnitude
wire sign_a, sign_b;
wire [N-2:0] mag_a, mag_b;

// Sign extraction
assign sign_a = a[N-1];
assign sign_b = b[N-1];

// Magnitude extraction and calculation
assign mag_a = (sign_a == 1'b0)? a[N-2:0] : ~(a[N-2:0]) + 1'b1;
assign mag_b = (sign_b == 1'b0)? b[N-2:0] : ~(b[N-2:0]) + 1'b1;

// Perform addition or subtraction based on signs
wire same_sign = (sign_a == sign_b);
wire [N-1:0] result;
assign result = same_sign? {sign_a, mag_a + mag_b} : (mag_a >= mag_b)? {1'b0, mag_a - mag_b} : {sign_b, mag_b - mag_a};

// Saturation logic for overflow handling
wire [N-1:0] max_value = {1'b1, {N-1{1'b1}}};
wire [N-1:0] min_value = {N{1'b0}};
assign c = (result >= max_value)? max_value : (result < min_value)? min_value : result;

endmodule