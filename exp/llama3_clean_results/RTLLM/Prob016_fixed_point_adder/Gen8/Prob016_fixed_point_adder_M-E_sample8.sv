module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

// Fractional part alignment
wire [N-1:0] aligned_a = (a[N-1] == 1'b1)? {1'b1, {Q{1'b0}}, a[N-Q-1:0]} : {1'b0, {Q{1'b0}}, a[N-Q-1:0]};
wire [N-1:0] aligned_b = (b[N-1] == 1'b1)? {1'b1, {Q{1'b0}}, b[N-Q-1:0]} : {1'b0, {Q{1'b0}}, b[N-Q-1:0]};

// Hybrid Carry-Save Adder (CSA)
wire [N:0] sum;
assign sum = aligned_a + aligned_b;

// Overflow detection and saturation
wire overflow = sum[N];
assign c = (overflow)? {1'b1, {N-1{1'b1}}} : sum[N-1:0];

// Sign-bit management
wire sign_c = (aligned_a[N-1] == aligned_b[N-1])? aligned_a[N-1] : (aligned_a[N-1]? 1'b1 : 1'b0);
assign c[N-1] = sign_c;

endmodule