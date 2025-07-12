module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Clock gating optimization for no-rotation cases
wire rotation_en = |ena[1:0] && ~load;  // Enable when either rotation is active and not loading

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (rotation_en) begin  // Only perform rotation when needed
        case (ena)
            2'b01: q <= {q[0], q[99:1]};  // Right rotate
            2'b10: q <= {q[98:0], q[99]};  // Left rotate
            default: q <= q;               // No rotation (handled by rotation_en)
        endcase
    end
    // Implicit else retains value (no power-hungry muxing when not rotating)
end

endmodule