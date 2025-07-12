module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Rotation control signals
wire do_rotate = |ena;  // Any rotation enabled
wire rotate_left = ena[1] & ~ena[0];
wire rotate_right = ~ena[1] & ena[0];

// Parallel rotation paths
wire [99:0] left_rotated = {q[98:0], q[99]};
wire [99:0] right_rotated = {q[0], q[99:1]};

// Combined rotation result
wire [99:0] rotated = rotate_left ? left_rotated : 
                     rotate_right ? right_rotated : q;

// Next state logic with load priority
wire [99:0] next_q = load ? data : (do_rotate ? rotated : q);

always @(posedge clk) begin
    q <= next_q;
end

endmodule