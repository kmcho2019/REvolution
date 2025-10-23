module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire [99:0] next_q;

// Rotation logic
wire [99:0] right_rot = {q[0], q[99:1]};
wire [99:0] left_rot = {q[98:0], q[99]};

// Next state calculation
assign next_q = load ? data :
                (ena == 2'b01) ? right_rot :
                (ena == 2'b10) ? left_rot :
                q;

// Sequential update
always @(posedge clk) begin
    q <= next_q;
end

endmodule