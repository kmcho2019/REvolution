module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] next_Q;

always @(*) begin
    if (~rst_n) begin
        next_Q = 64'd0;
    end else if (Q[0] == 1'b0) begin
        next_Q = {1'b1, Q[63:1]};
    end else begin
        next_Q = {1'b0, Q[63:1]};
    end
end

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule