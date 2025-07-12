module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [31:0] upper_stage;
wire counter_active = !(&Q || ~|Q); // Clock gating when all 1s or all 0s
wire clk_gated = clk & counter_active;

always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        upper_stage <= 32'b0;
    end else begin
        // First pipeline stage: process upper 32 bits
        upper_stage <= {~Q[0], Q[63:33]};
        
        // Second pipeline stage: process lower 32 bits
        Q <= {upper_stage, Q[32:1]};
    end
end

endmodule