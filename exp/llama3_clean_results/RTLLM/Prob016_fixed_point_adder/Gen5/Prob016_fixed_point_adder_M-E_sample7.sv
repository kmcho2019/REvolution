module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

// Sign detection unit
wire sign_a = a[N-1];
wire sign_b = b[N-1];
wire same_sign = sign_a == sign_b;

// Magnitude processing unit
wire [N-1:0] abs_a = sign_a? (~a + 1) : a;
wire [N-1:0] abs_b = sign_b? (~b + 1) : b;
wire larger_abs = (abs_a > abs_b)? 1'b1 : 1'b0;

// Dual-path arithmetic
wire [N:0] add_result = a + b;
wire [N:0] sub_result = (larger_abs == 1'b1)? (a - b) : (b - a);

// Overflow handling unit
wire overflow = (add_result[N] == 1'b1) || (sub_result[N] == 1'b1);
wire [N-1:0] saturated_result = (overflow == 1'b1)? ((1 << (N-1)) - 1) : (add_result[N-1:0]);

// Output assignment
assign c = (same_sign == 1'b1)? saturated_result : (overflow == 1'b1)? ((1 << (N-1)) - 1) : sub_result[N-1:0];

endmodule