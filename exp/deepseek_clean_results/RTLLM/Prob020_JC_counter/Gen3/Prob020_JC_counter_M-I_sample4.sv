module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

wire terminal_state = &Q || ~|Q;  // Detect all 1s or all 0s
reg gated_clk;

always @(*) begin
    gated_clk = clk & (~terminal_state | !rst_n);
end

always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= {~Q[0], Q[63:1]};  // Combined shift and MSB selection
    end
end

endmodule