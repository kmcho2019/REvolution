module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Stage 1: Sign detection
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Compute absolute values
wire [N-1:0] abs_a = sign_a? (~a + 1'b1) : a;
wire [N-1:0] abs_b = sign_b? (~b + 1'b1) : b;

// Stage 2: Determine operation based on signs
wire add_op = sign_a == sign_b;
wire [N:0] sum = add_op? (abs_a + abs_b) : (abs_a > abs_b)? (abs_a - abs_b) : (abs_b - abs_a);

// Overflow and underflow management
wire overflow = sum[N];
wire underflow = sum[N] ^ add_op;

// Construct the final result
assign c = (overflow || underflow)?
    ((overflow && add_op)? (1 << N) - 1 : 0) :
    (add_op)? {sign_a, sum[N-1:0]} : (sum[N]? {1'b1, sum[N-1:0]} : {1'b0, sum[N-1:0]});

endmodule