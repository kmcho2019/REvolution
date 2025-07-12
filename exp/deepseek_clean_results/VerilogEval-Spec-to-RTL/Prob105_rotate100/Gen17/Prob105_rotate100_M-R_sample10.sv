module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Combinational rotation logic
wire [99:0] right_rot = {q[0], q[99:1]};
wire [99:0] left_rot = {q[98:0], q[99]};
wire [99:0] next_q;

assign next_q = load ? data :  // Load has highest priority
               (ena == 2'b01) ? right_rot :
               (ena == 2'b10) ? left_rot :
               q;  // Default case (no rotation)

// Sequential element
always @(posedge clk) begin
    q <= next_q;
end

endmodule