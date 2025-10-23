module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire rotate_enable = |ena;  // High when rotation is needed
wire [99:0] next_q;

// Rotation logic (barrel shifter style)
assign next_q = (ena == 2'b01) ? {q[0], q[99:1]} :  // Right rotate
                (ena == 2'b10) ? {q[98:0], q[99]} :  // Left rotate
                q;                                   // Default

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (rotate_enable) begin
        q <= next_q;
    end
    // Implicit else: q retains value (no clock gating needed at RTL level)
end

endmodule