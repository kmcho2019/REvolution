module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

// Determine signs of a and b
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Calculate absolute values of a and b
wire [N-1:0] abs_a = sign_a ? (~a + 1) : a;
wire [N-1:0] abs_b = sign_b ? (~b + 1) : b;

// Perform addition or subtraction based on sign bits
wire [N:0] sum = abs_a + abs_b;
wire [N:0] diff = abs_a - abs_b;

// Select between sum and difference based on signs
wire [N:0] result = (sign_a == sign_b) ? sum : (sign_a ? diff : sum);

// Overflow handling: saturate if overflow occurs
wire overflow = result[N];
assign c = (overflow) ? {1'b1, {N-1{1'b1}}} : result[N-1:0];

endmodule