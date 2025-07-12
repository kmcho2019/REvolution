module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire [99:0] next_q;

// Calculate next state of the rotator
assign next_q = load ? data :
                (ena == 2'b01) ? {q[0], q[99:1]} : // rotate right
                (ena == 2'b10) ? {q[98:0], q[99]} : // rotate left
                q; // no rotation

// Update current state on rising edge of the clock
always @(posedge clk) begin
    q <= next_q;
end

endmodule