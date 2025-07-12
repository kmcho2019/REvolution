module TopModule (
    input clk,
    input d,
    output reg q
);

reg q_pos, q_neg;
reg prev_clk;

always @(posedge clk) begin
    q_pos <= d;
    prev_clk <= 1'b1;
end

always @(negedge clk) begin
    q_neg <= d;
    prev_clk <= 1'b0;
end

always @(*) begin
    q = prev_clk ? q_neg : q_pos;
end

endmodule