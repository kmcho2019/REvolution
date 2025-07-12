module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire [99:0] rotate_left, rotate_right;
wire [99:0] next_q;

// Precompute rotated versions:
assign rotate_left  = {q[98:0], q[99]};  // left rotate by 1
assign rotate_right = {q[0], q[99:1]};   // right rotate by 1

// Select next state based on load and ena:
assign next_q = load        ? data            : // load has highest priority
                (ena == 2'b10) ? rotate_left  :
                (ena == 2'b01) ? rotate_right :
                q;

always @(posedge clk) begin
    q <= next_q;
end

endmodule