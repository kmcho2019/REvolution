module TopModule (
    input clk,
    input d,
    output reg q
);

reg q_pos, q_neg;
reg clk_delayed;

always @(posedge clk) begin
    q_pos <= d;
    clk_delayed <= 1'b1;
end

always @(negedge clk) begin
    q_neg <= d;
    clk_delayed <= 1'b0;
end

always @(*) begin
    q = clk_delayed ? q_neg : q_pos;
end

endmodule