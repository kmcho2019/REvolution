module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos;
reg q_neg;
reg prev_clk;

always @(posedge clk) begin
    q_pos <= d;
end

always @(negedge clk) begin
    q_neg <= d;
end

always @(posedge clk or negedge clk) begin
    if (clk != prev_clk) begin
        q <= (clk == 1'b1) ? q_pos : q_neg;
    end
    prev_clk <= clk;
end

endmodule