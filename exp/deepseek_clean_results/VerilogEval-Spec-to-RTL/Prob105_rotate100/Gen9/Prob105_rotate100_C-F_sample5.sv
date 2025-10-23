module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Rotation control signals
wire rotate_left  = (ena == 2'b10);
wire rotate_right = (ena == 2'b01);

// Next state logic
wire [99:0] next_q_rotate;
wire [99:0] next_q;

// Rotation mux
assign next_q_rotate = rotate_left  ? {q[98:0], q[99]} :
                       rotate_right ? {q[0], q[99:1]} :
                       q;

// Load has priority over rotation
assign next_q = load ? data : next_q_rotate;

// Synchronous update
always @(posedge clk) begin
    q <= next_q;
end

endmodule