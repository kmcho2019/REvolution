module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Stage 1: Input Normalization
wire [N-1:0] norm_a, norm_b;
assign norm_a = (a[N-1] == 1'b0)? {a[N-1], a[N-2:Q], {Q{1'b0}}} : {a[N-1], ~(a[N-2:Q]), {Q{1'b1}}};
assign norm_b = (b[N-1] == 1'b0)? {b[N-1], b[N-2:Q], {Q{1'b0}}} : {b[N-1], ~(b[N-2:Q]), {Q{1'b1}}};

// Stage 2: Sign and Magnitude Separation
wire sign_a = norm_a[N-1];
wire sign_b = norm_b[N-1];
wire [N-2:0] mag_a = (sign_a == 1'b0)? norm_a[N-2:0] : ~(norm_a[N-2:0]) + 1'b1;
wire [N-2:0] mag_b = (sign_b == 1'b0)? norm_b[N-2:0] : ~(norm_b[N-2:0]) + 1'b1;

// Stage 3: Arithmetic Logic
wire same_sign = (sign_a == sign_b);
wire [N-1:0] mag_res;
assign mag_res = same_sign? {1'b0, mag_a + mag_b} : (mag_a >= mag_b)? {1'b0, mag_a - mag_b} : {1'b1, mag_b - mag_a};

// Stage 4: Overflow Detection and Saturation
wire overflow = (mag_res[N-1] == 1'b1);
wire [N-1:0] sat_res;
assign sat_res = overflow? (1 << N) - 1 : mag_res;

// Stage 5: Output Formatting
assign c = sat_res;

endmodule