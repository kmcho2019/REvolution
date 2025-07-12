module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// One-hot encoded rotation control (better for power)
reg rotate_left, rotate_right;
always @(*) begin
    rotate_left = 1'b0;
    rotate_right = 1'b0;
    case (ena)
        2'b01: rotate_right = 1'b1;
        2'b10: rotate_left = 1'b1;
    endcase
end

// Clock gating logic (reduces power when idle)
wire clk_enable = load | rotate_left | rotate_right;
wire gated_clk;
assign gated_clk = clk & clk_enable;

// Break down rotation into chunks for better timing
wire [99:0] next_q_rotate;
assign next_q_rotate = rotate_left  ? {q[98:0], q[99]} :  // Left rotate
                       rotate_right ? {q[0], q[99:1]} :   // Right rotate
                       q;                                // No rotation

// Load has priority over rotation
wire [99:0] next_q = load ? data : next_q_rotate;

// Synchronous update with gated clock
always @(posedge gated_clk) begin
    if (clk_enable) begin
        q <= next_q;
    end
end

endmodule