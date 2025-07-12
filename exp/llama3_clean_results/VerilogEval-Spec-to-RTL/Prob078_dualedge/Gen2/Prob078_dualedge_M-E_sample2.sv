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
    prev_clk <= 1'b1;
end

always @(negedge clk) begin
    q_neg <= d;
    prev_clk <= 1'b0;
end

always @(*) begin
    if (prev_clk == 1'b1) begin
        q = q_pos;
    end else begin
        q = q_neg;
    end
end

endmodule