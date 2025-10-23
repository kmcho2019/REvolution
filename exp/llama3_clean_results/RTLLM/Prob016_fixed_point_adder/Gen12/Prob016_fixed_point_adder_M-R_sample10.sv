module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Sign Extraction Unit (SEU)
wire sign_a = a[N-1];
wire sign_b = b[N-1];
wire same_sign = sign_a == sign_b;
wire diff_sign = ~same_sign;

// Absolute Value Generator (AVG)
wire [N-1:0] abs_a = sign_a? {~a[N-1], ~a[N-2:0]} + 1 : a;
wire [N-1:0] abs_b = sign_b? {~b[N-1], ~b[N-2:0]} + 1 : b;

// Shift-and-Add Unit (SAU) with Overflow Detection
wire [N:0] sa_result = same_sign? (abs_a + abs_b) : (abs_a > abs_b)? (abs_a - abs_b) : (abs_b - abs_a);

// Overflow Detection and Correction Unit (ODCU)
assign c = sa_result[N]? {sign_a, {N-1{1'b0}}} : sa_result[N-1:0];

endmodule