module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Pre-compute all possible rotation outcomes
wire [99:0] right_rot = {q[0], q[99:1]};  // Right rotate
wire [99:0] left_rot  = {q[98:0], q[99]}; // Left rotate
wire [99:0] no_rot    = q;                // No rotation

// Select rotation based on ena
wire [99:0] rotated = (ena == 2'b01) ? right_rot :
                     (ena == 2'b10) ? left_rot :
                     no_rot;

// Synchronous update with load priority
always @(posedge clk) begin
    q <= load ? data : rotated;
end

endmodule