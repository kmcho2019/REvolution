module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Internal wires
wire [N-1:0] abs_a, abs_b;
wire [N:0] sum;
wire overflow;

// Calculate absolute values
assign abs_a = (a[N-1])? (~a + 1) : a;
assign abs_b = (b[N-1])? (~b + 1) : b;

// Perform addition
assign sum = abs_a + abs_b;

// Detect overflow
assign overflow = (sum[N] == 1);

// Sign handling unit
wire sign_result;
assign sign_result = (a[N-1] && b[N-1] && sum[N]) || 
                     (a[N-1] &&!b[N-1] && (abs_a > abs_b)) || 
                     (!a[N-1] && b[N-1] && (abs_b > abs_a));

// Precision maintenance and result formation
assign c = (overflow)? {1'b1, {N-1{1'b0}}} : 
               ({sign_result, sum[N-1:0]});

endmodule