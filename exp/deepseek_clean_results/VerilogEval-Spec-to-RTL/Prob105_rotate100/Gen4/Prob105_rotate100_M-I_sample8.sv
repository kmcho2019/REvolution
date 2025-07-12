module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire rotate_en = |ena;  // Rotation enable (any non-zero ena)
wire clk_gated = clk & (load | rotate_en);  // Clock gating

always @(posedge clk_gated) begin
    if (load) begin
        q <= data;
    end
    else if (rotate_en) begin
        // Split into two 50-bit rotations to reduce critical path
        case (ena)
            2'b01: begin  // Right rotate
                q[49:0]  <= {q[0], q[49:1]};
                q[99:50] <= {q[50], q[99:51]};
            end
            2'b10: begin  // Left rotate
                q[48:0]  <= q[49:1];
                q[49]     <= q[0];
                q[98:50] <= q[99:51];
                q[99]    <= q[50];
            end
        endcase
    end
end

endmodule