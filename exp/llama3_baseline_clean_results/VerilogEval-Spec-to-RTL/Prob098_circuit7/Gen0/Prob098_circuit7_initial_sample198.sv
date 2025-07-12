module TopModule(
    input clk,
    input a,
    output q
);

reg q_reg;

always @(posedge clk) begin
    if (a == 0) begin
        q_reg <= 1;
    end else if (q_reg == 1) begin
        q_reg <= 0;
    end
end

assign q = q_reg;

endmodule