module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] next_Q;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0;
    end else begin
        Q <= next_Q;
    end
end

always @(*) begin
    case (Q[0])
        1'b0: next_Q = {1'b1, Q[63:1]};
        1'b1: next_Q = {1'b0, Q[63:1]};
        default: next_Q = Q;
    endcase
end

endmodule