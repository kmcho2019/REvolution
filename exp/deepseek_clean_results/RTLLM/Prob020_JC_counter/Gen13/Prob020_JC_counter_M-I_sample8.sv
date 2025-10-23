module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [31:0] stage1;
reg terminal_state;
wire clk_gated;

// Clock gating cell
assign clk_gated = terminal_state ? 1'b0 : clk;

always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        stage1 <= 32'b0;
    end else begin
        // First pipeline stage - upper 32 bits
        stage1 <= {~Q[0], Q[63:33]};
        
        // Second pipeline stage - lower 32 bits
        Q <= {stage1, Q[32:1]};
    end
end

// Terminal state detection
always @(*) begin
    terminal_state = (Q == 64'h0) || (&Q == 1'b1);
end

endmodule