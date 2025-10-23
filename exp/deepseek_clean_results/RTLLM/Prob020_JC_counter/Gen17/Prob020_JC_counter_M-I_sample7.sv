module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg gated_clk;
reg [63:0] Q_next;
wire extreme_state = &Q || ~|Q; // All 1s or all 0s

always @(*) begin
    Q_next = {~Q[0], Q[63:1]};
end

// Clock gating logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        gated_clk <= 1'b0;
    end else begin
        gated_clk <= ~extreme_state;
    end
end

// Pipelined register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else if (gated_clk) begin
        Q <= Q_next;
    end
end

endmodule