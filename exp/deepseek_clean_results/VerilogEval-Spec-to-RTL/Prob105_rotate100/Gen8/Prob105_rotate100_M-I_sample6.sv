module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Clock gating signal
wire clk_en = load | (|ena);

always @(posedge clk) begin
    if (clk_en) begin
        if (load) begin
            q <= data;  // Synchronous load has highest priority
        end else begin
            case (ena)
                2'b01: begin  // Right rotate
                    q[99:50] <= {q[0], q[99:51]};  // Stage 1: upper 50 bits
                    q[49:0] <= {q[50], q[49:1]};   // Stage 2: lower 50 bits
                end
                2'b10: begin  // Left rotate
                    q[99:50] <= {q[48:0], q[99]};   // Stage 1: upper 50 bits
                    q[49:0] <= {q[98:50], q[49]};   // Stage 2: lower 50 bits
                end
                default: q <= q;  // No rotation (clock gated)
            endcase
        end
    end
end

endmodule