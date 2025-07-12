module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire rotate_en = |ena;  // Rotation enable (ena != 0)

always @(posedge clk) begin
    if (load) begin
        q <= data;  // Synchronous load has highest priority
    end else if (rotate_en) begin  // Only evaluate rotation if needed
        case (ena)
            2'b01: q <= {q[0], q[99:1]};  // Right rotate
            2'b10: q <= {q[98:0], q[99]};  // Left rotate
            default: q <= q;               // Shouldn't happen due to rotate_en
        endcase
    end
    // Implicit else: q retains value (no clock gating shown here)
end

endmodule