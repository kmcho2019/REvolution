module TopModule (
    input clk,
    input a,
    output q
);

reg q_reg;
initial q_reg = 1'b0;

always @(posedge clk) begin
    if (a) begin
        q_reg <= ~q_reg;
    end else begin
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule