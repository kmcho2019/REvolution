module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

// Calculate absolute values and determine operation based on MSBs
wire [N-1:0] abs_a = (a[N-1] == 1'b0) ? a : -a;
wire [N-1:0] abs_b = (b[N-1] == 1'b0) ? b : -b;

// Perform addition or subtraction based on MSBs
wire [N-1:0] result_add = abs_a + abs_b;
wire [N-1:0] result_sub = (a[N-1] == 1'b0) ? abs_a - abs_b : abs_b - abs_a;

// Select result based on MSBs
wire [N-1:0] result = (a[N-1] == b[N-1]) ? result_add : result_sub;

// Apply saturation for overflow
wire [N-1:0] saturated_result = (result >= (1 << (N-1))) ? (1 << (N-1)) - 1 :
                                (result < -(1 << (N-1))) ? -(1 << (N-1)) : result;

// Assign output with correct sign
assign c = saturated_result;

endmodule