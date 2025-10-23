module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire [99:0] left_rotated = {q[98:0], q[99]};
wire [99:0] right_rotated = {q[0], q[99:1]};
wire rotate_en = |ena;  // Enable when either rotation direction is active
wire clk_en = load | rotate_en;

reg [99:0] next_q;

always @(*) begin
    case ({load, ena})
        3'b100: next_q = data;       // Load case
        3'b001: next_q = right_rotated;  // Right rotate
        3'b010: next_q = left_rotated;   // Left rotate
        default: next_q = q;         // Hold state
    endcase
end

// Clock gated register
always @(posedge clk) begin
    if (clk_en) begin
        q <= next_q;
    end
end

endmodule