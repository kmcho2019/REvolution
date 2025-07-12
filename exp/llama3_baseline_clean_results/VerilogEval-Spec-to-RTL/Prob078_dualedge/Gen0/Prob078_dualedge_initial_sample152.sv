module TopModule(
    input clk,
    input d,
    output q
);

reg q_pos, q_neg;

always @(posedge clk) begin
    q_pos <= d;
end

always @(negedge clk) begin
    q_neg <= d;
end

assign q = (clk == 1'b0)? q_neg : q_pos;

endmodule