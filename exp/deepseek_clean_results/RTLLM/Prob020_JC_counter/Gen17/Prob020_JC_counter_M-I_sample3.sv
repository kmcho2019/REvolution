module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

wire wrap_around = (Q == 64'h0) || (Q == 64'hFFFFFFFFFFFFFFFF);
wire gated_clk = clk & ~wrap_around;

always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        // Two-stage pipelined shift with balanced logic
        Q[63:32] <= {~Q[0], Q[63:33]};
        Q[31:0] <= {Q[32], Q[31:1]};
    end
end

endmodule