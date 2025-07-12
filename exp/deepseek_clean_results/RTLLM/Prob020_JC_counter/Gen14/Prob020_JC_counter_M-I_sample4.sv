module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] Q_next;
wire counter_enable = (Q != 64'hFFFFFFFFFFFFFFFF) && (Q != 0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 0;
        Q_next <= 0;
    end
    else if (counter_enable) begin
        Q_next <= {~Q[0], Q[63:1]};
        Q <= Q_next;
    end
end

endmodule