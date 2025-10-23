module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Clock gating logic
wire clk_en = load || (ena != 2'b00 && ena != 2'b11);
wire gated_clk = clk & clk_en;

// Rotation logic
wire [99:0] right_rot = {q[0], q[99:1]};
wire [99:0] left_rot = {q[98:0], q[99]};

// Next state logic
always @(*) begin
    if (load) begin
        q = data;  // Highest priority: synchronous load
    end else begin
        case (ena)
            2'b01: q = right_rot;  // Right rotate
            2'b10: q = left_rot;   // Left rotate
            default: q = q;        // No rotation (ena=00 or 11)
        endcase
    end
end

// Synchronous update with clock gating
always @(posedge gated_clk) begin
    if (clk_en) begin
        q <= q;  // Update only when needed
    end
end

endmodule