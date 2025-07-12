module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire q_comb;

assign q_comb = state ^ (a ^ b);
assign q = q_comb;

always @(posedge clk) begin
    state <= q_comb;
end

endmodule