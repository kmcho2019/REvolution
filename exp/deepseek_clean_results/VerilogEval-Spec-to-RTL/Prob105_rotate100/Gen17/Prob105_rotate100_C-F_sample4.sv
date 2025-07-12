module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Explicit rotation control signals
wire rotate_left  = (ena == 2'b10);
wire rotate_right = (ena == 2'b01);
wire no_rotate    = (ena == 2'b00) || (ena == 2'b11);

// Rotation logic
wire [99:0] next_left  = {q[98:0], q[99]};
wire [99:0] next_right = {q[0], q[99:1]};

// Next state logic with clear priority
wire [99:0] next_q = load       ? data :
                     rotate_left  ? next_left :
                     rotate_right ? next_right :
                     q;

always @(posedge clk) begin
    q <= next_q;
end

endmodule