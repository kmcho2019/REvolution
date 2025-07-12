module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

reg [99:0] q_next;
reg [49:0] stage1_upper, stage1_lower;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        case (ena)
            2'b01: begin  // Right rotate
                stage1_upper <= q[49:0];
                stage1_lower <= q[99:50];
                q <= {stage1_upper[0], stage1_upper[49:1], 
                      stage1_lower[0], stage1_lower[49:1]};
            end
            2'b10: begin  // Left rotate
                stage1_upper <= q[49:0];
                stage1_lower <= q[99:50];
                q <= {stage1_upper[48:0], stage1_upper[49],
                      stage1_lower[48:0], stage1_lower[49]};
            end
            default: q <= q;  // No change (implicit clock gating)
        endcase
    end
end

endmodule