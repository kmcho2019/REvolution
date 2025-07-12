module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire rotate_en = |ena;  // Enable when any rotation is requested
wire clk_en = load | rotate_en;
wire [99:0] next_q;

// Shared rotation logic
wire [99:0] right_rot = {q[0], q[99:1]};
wire [99:0] left_rot = {q[98:0], q[99]};

// Optimized muxing
assign next_q = load ? data :
                (ena[1] ? left_rot : right_rot);

always @(posedge clk) begin
    if (clk_en) begin
        q <= next_q;
    end
end

endmodule