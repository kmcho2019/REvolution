module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire rotate_en = |ena;  // Rotation enable (ena != 0)
wire [99:0] next_q;

// Rotation logic
assign next_q = (ena[0]) ? {q[0], q[99:1]} :  // Right rotate when ena=01
                (ena[1]) ? {q[98:0], q[99]} :  // Left rotate when ena=10
                q;                             // Default (no rotation)

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (rotate_en) begin
        q <= next_q;
    end
    // Implicit else: q retains value (clock gated by synthesis)
end

endmodule