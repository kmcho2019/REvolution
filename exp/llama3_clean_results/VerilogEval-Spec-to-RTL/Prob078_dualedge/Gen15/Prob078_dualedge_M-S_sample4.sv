module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos;
reg q_neg;

always @(posedge clk) begin
    q_pos <= d;
end

always @(negedge clk) begin
    q_neg <= d;
end

assign q = (clk == 1'b1) ? q_pos : q_neg;

endmodule