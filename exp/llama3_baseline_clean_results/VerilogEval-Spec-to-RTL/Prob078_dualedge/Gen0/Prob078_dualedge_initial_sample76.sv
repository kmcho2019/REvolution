module TopModule(
    input clk,
    input d,
    output q
);

reg q_reg;
reg prev_clk;

always @(posedge clk) begin
    prev_clk <= 1'b1;
    if (~prev_clk) begin
        q_reg <= d;
    end
end

always @(negedge clk) begin
    prev_clk <= 1'b0;
    if (prev_clk) begin
        q_reg <= d;
    end
end

assign q = q_reg;

initial begin
    prev_clk = 1'b0;
    q_reg = 1'b0;
end

endmodule