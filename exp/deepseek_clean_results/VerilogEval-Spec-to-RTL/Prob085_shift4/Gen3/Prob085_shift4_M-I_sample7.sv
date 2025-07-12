module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

wire clk_gated = clk & (load | ena | areset); // Simple clock gating

always @(posedge clk_gated or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end else begin
        case ({load,ena})
            2'b10, 2'b11: q <= data;  // load has priority
            2'b01:        q <= {1'b0, q[3:1]};
            default:      q <= q;      // no change
        endcase
    end
end

endmodule