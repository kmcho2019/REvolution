module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos;
reg q_neg;
reg clk_prev;

always @(posedge clk or negedge clk) begin
    if (clk!= clk_prev) begin
        if (clk == 1'b1) begin
            q_pos <= d;
        end else begin
            q_neg <= d;
        end
        clk_prev <= clk;
    end
end

assign q = (clk == 1'b1)? q_pos : q_neg;

endmodule