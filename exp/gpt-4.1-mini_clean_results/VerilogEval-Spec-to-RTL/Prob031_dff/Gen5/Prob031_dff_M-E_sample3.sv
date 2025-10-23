module TopModule(
    input clk,
    input d,
    output reg q
);

reg d_reg;

always @(posedge clk) begin
    d_reg <= d;
end

always @(*) begin
    q = d_reg;
end

endmodule