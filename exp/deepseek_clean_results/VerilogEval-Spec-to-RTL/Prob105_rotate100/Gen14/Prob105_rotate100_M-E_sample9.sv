module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Pre-compute both rotation directions
wire [99:0] right_rot = {q[0], q[99:1]};  // Right rotate by 1
wire [99:0] left_rot = {q[98:0], q[99]};   // Left rotate by 1

// Unified rotation selection logic
wire [99:0] next_q = 
    load ? data :               // Highest priority: load
    (ena == 2'b01) ? right_rot : // Right rotate
    (ena == 2'b10) ? left_rot :  // Left rotate
    q;                          // Default: hold value

always @(posedge clk) begin
    q <= next_q;
end

endmodule