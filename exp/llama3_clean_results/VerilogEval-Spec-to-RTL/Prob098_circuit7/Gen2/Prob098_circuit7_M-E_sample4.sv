module TopModule(
    input  clk,
    input  a,
    output q
);

reg q_reg;
assign q = q_reg;

always @(posedge clk or posedge a) begin
    if (a == 0) begin
        q_reg <= 1;
    end else if (q_reg == 1 && a == 1) begin
        q_reg <= 0;
    end else begin
        q_reg <= q_reg;
    end
end

endmodule