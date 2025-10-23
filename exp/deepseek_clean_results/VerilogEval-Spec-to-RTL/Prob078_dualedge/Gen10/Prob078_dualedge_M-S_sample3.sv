module TopModule (
    input clk,
    input d,
    output q
);

reg q_reg;
reg prev_clk;

always @(posedge clk) begin
    prev_clk <= 1'b1;
    q_reg <= d;
end

always @(negedge clk) begin
    prev_clk <= 1'b0;
    q_reg <= d;
end

assign q = (clk ^ prev_clk) ? d : q_reg;

endmodule