module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg Q0_reg;
wire terminal_state = &Q || ~|Q; // All 1s or all 0s
wire gated_clk = clk & ~terminal_state;

always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        Q0_reg <= 1'b0;
    end
    else begin
        Q0_reg <= Q[0];
        Q <= {~Q0_reg, Q[63:1]};
    end
end

endmodule