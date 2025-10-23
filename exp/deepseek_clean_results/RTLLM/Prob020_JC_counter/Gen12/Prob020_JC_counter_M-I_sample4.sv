module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [31:0] Q_upper;
wire counter_enable = (Q != 64'hFFFFFFFF) && (Q != 64'h00000000);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'h00000000;
    end
    else if (counter_enable) begin
        // Two-stage shift for better timing
        Q_upper <= {~Q[0], Q[63:32]};
        Q <= {Q_upper[31:0], Q[31:1]};
    end
end

endmodule