module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Clock gating signal
wire clk_en = load || (ena != 2'b00 && ena != 2'b11);

// Hierarchical rotation implementation
always @(posedge clk) begin
    if (clk_en) begin
        if (load) begin
            q <= data;  // Synchronous load has highest priority
        end else begin
            case (ena)
                2'b01: begin  // Right rotate
                    q <= {q[0], q[99:1]};  // LSB becomes MSB
                end
                2'b10: begin  // Left rotate
                    q <= {q[98:0], q[99]};  // MSB becomes LSB
                end
                default: q <= q;  // No rotation (clock gated)
            endcase
        end
    end
end

endmodule