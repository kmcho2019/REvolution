module TopModule(
    input clk,
    input d,
    output q
);

reg q_reg;
reg clk_prev;
reg clk_edge;

always @(posedge clk or negedge clk) begin
    clk_edge = 1'b1;
end

always @(*) begin
    if (clk != clk_prev) begin
        if (d) begin
            q_reg = 1'b1;
        end else begin
            q_reg = 1'b0;
        end
    end
    clk_prev = clk;
end

assign q = q_reg;

endmodule