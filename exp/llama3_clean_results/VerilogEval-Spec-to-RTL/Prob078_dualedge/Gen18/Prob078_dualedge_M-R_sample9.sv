module TopModule(
    input clk,
    input d,
    output reg q
);

reg clk_prev;
reg q_pos;
reg q_neg;

always @(posedge clk or negedge clk) begin
    if (clk!= clk_prev) begin
        if (clk == 1'b1) begin
            q_pos <= d;
        end else begin
            q_neg <= d;
        end
    end
    clk_prev <= clk;
end

always @(clk or q_pos or q_neg) begin
    if (clk == 1'b1) begin
        q <= q_pos;
    end else begin
        q <= q_neg;
    end
end

endmodule