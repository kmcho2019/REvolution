module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [31:0] Q_stage1;
reg next_msb;
wire clk_gated;

// Clock gating for power optimization
assign clk_gated = clk & !((&Q) || (~|Q)); // Disable clock when all 1s or all 0s

always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        Q_stage1 <= 32'b0;
        next_msb <= 1'b0;
    end else begin
        // Pipeline stage 1: Compute next MSB and first shift
        next_msb <= ~Q[0];
        Q_stage1 <= Q[63:32];
        
        // Pipeline stage 2: Complete the shift
        Q <= {next_msb, Q_stage1, Q[31:1]};
    end
end

endmodule