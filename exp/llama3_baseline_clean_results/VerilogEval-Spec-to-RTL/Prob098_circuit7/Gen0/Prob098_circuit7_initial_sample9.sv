module TopModule (
    input clk,
    input a,
    output q
);

reg q_reg;
assign q = q_reg;

always @ (posedge clk) begin
    if (a) begin
        q_reg <= ~q_reg;
    end else begin
        q_reg <= q_reg;
    end
end

endmodule