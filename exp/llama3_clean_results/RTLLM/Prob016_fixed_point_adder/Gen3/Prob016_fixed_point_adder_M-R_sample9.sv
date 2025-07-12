module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

// Calculate absolute values
wire [N-1:0] abs_a = (a[N-1] == 1'b0) ? a : (~a + 1'b1);
wire [N-1:0] abs_b = (b[N-1] == 1'b0) ? b : (~b + 1'b1);

// Determine operation based on MSBs
wire add_op = (a[N-1] == b[N-1]);

// Perform addition or subtraction
wire [N-1:0] result = add_op ? (abs_a + abs_b) : (a[N-1] == 1'b0) ? (abs_a - abs_b) : (abs_b - abs_a);

// Apply saturation for overflow
wire [N-1:0] saturated_result = (result >= (1 << (N-1))) ? (1 << (N-1)) - 1 :
                                (result < -(1 << (N-1))) ? -(1 << (N-1)) : result;

// Assign output with correct sign
assign c = saturated_result;

endmodule