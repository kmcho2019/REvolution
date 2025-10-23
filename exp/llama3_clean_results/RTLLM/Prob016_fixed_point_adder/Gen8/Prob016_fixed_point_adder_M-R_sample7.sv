module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

// Determine signs of operands
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Calculate absolute values
wire [N-1:0] abs_a = sign_a? {~a[N-1], a[N-2:0]} + 1 : a;
wire [N-1:0] abs_b = sign_b? {~b[N-1], b[N-2:0]} + 1 : b;

// Perform addition or subtraction based on signs
wire [N:0] temp_res;
assign temp_res = (sign_a == sign_b)? abs_a + abs_b :
                  (abs_a >= abs_b)? abs_a - abs_b :
                                   abs_b - abs_a;

// Handle overflow
assign c = (temp_res[N])? {N{1'b1}} : temp_res[N-1:0];

endmodule