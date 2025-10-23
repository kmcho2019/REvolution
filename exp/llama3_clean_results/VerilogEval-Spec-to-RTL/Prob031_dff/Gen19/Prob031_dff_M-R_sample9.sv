module TopModule(
    input clk,
    input d,
    output reg q = 1'b0
);

reg q_reg;

always @(posedge clk) begin
    q_reg <= d;
end

assign q = q_reg;

endmodule