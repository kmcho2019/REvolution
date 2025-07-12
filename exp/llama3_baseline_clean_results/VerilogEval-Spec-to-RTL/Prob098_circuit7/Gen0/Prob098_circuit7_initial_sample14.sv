module TopModule(
    input clk,
    input a,
    output q
);

reg q_reg;

always @(posedge clk) begin
    if (a) begin
        q_reg = ~q_reg;
    end
end

assign q = q_reg;

endmodule