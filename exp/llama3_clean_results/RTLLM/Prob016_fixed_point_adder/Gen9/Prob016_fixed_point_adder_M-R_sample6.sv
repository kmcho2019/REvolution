module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input clk,
    input rst_n,
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Stage 1: Input Normalization and Sign Separation
wire [N-1:0] norm_a = (a[N-1] == 1'b0)? {a[N-1], a[N-2:Q], {Q{1'b0}}} : {a[N-1], ~(a[N-2:Q]), {Q{1'b1}}};
wire [N-1:0] norm_b = (b[N-1] == 1'b0)? {b[N-1], b[N-2:Q], {Q{1'b0}}} : {b[N-1], ~(b[N-2:Q]), {Q{1'b1}}};

wire sign_a = norm_a[N-1];
wire sign_b = norm_b[N-1];

wire [N-2:0] mag_a = (sign_a == 1'b0)? norm_a[N-2:0] : ~(norm_a[N-2:0]) + 1'b1;
wire [N-2:0] mag_b = (sign_b == 1'b0)? norm_b[N-2:0] : ~(norm_b[N-2:0]) + 1'b1;

// Stage 2: Arithmetic Logic
wire same_sign = (sign_a == sign_b);
wire [N-1:0] mag_res = same_sign? {1'b0, mag_a + mag_b} : (mag_a >= mag_b)? {1'b0, mag_a - mag_b} : {1'b1, mag_b - mag_a};

// Stage 3: Overflow Detection and Saturation
wire overflow = (mag_res[N-1] == 1'b1);
reg [N-1:0] sat_res;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sat_res <= 0;
    end else if (overflow) begin
        sat_res <= (1 << N) - 1;
    end else begin
        sat_res <= mag_res;
    end
end

// Stage 4: Output Formatting
assign c = sat_res;

endmodule