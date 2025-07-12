module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Pre-compute both rotation directions
wire [99:0] right_rot = {q[0], q[99:1]};
wire [99:0] left_rot = {q[98:0], q[99]};

always @(posedge clk) begin
    case ({load, ena})
        3'b1_xx: q <= data;       // Load has highest priority
        3'b0_01: q <= right_rot;  // Right rotate
        3'b0_10: q <= left_rot;   // Left rotate
        default: q <= q;          // No change (includes ena=00 and 11)
    endcase
end

endmodule