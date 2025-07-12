module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Stage 1: Sign and Magnitude Extraction
wire sign_a = a[N-1];
wire sign_b = b[N-1];
wire [N-2:0] mag_a = (sign_a == 1'b0)? a[N-2:0] : ~(a[N-2:0]) + 1'b1;
wire [N-2:0] mag_b = (sign_b == 1'b0)? b[N-2:0] : ~(b[N-2:0]) + 1'b1;

// Stage 2: Magnitude Calculation
wire same_sign = (sign_a == sign_b);
wire [N-1:0] mag_res;
assign mag_res = same_sign? (mag_a + mag_b) : (mag_a >= mag_b)? (mag_a - mag_b) : (mag_b - mag_a);

// Stage 3: Addition/Subtraction and Normalization
wire [N-1:0] temp_res;
assign temp_res = same_sign? {sign_a, mag_res} : (mag_a >= mag_b)? {1'b0, mag_res} : {sign_b, mag_res};

// Saturation Logic for Overflow Handling
assign c = (temp_res >= (1 << N) - 1)? (1 << N) - 1 : (temp_res < 0)? 0 : temp_res;

endmodule