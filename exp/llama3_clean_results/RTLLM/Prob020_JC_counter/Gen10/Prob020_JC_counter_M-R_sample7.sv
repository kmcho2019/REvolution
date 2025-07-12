module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] Q_next;

assign Q_next = Q[0] ? {1'b0, Q[63:1]} : {1'b1, Q[63:1]};

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0;
    end else begin
        Q <= Q_next;
    end
end

endmodule