module TopModule(
    input clk,
    input d,
    output q
);

reg q_reg;
reg q_reg_prev;
reg clk_prev;

always @(posedge clk) begin
    clk_prev <= 1'b1;
    if (clk_prev == 1'b0) begin
        q_reg <= d;
    end
end

always @(negedge clk) begin
    clk_prev <= 1'b0;
    if (clk_prev == 1'b1) begin
        q_reg <= d;
    end
end

assign q = q_reg;

initial begin
    q_reg = 1'b0;
    q_reg_prev = 1'b0;
    clk_prev = 1'b0;
end

endmodule