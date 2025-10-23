module TopModule(
    input clk,
    input d,
    output q
);

reg q_reg;
reg clk_prev;

always @(posedge clk or negedge clk) begin
    if (clk !== clk_prev) begin
        q_reg <= d;
    end
    clk_prev <= clk;
end

assign q = q_reg;

endmodule