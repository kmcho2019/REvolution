module TopModule(
    input clk,
    input d,
    input r,
    output q
);

reg q_reg;
assign q = q_reg;

always @(posedge clk) begin
    if (r) begin
        q_reg <= 1'b0;
    end else begin
        q_reg <= d;
    end
end

endmodule