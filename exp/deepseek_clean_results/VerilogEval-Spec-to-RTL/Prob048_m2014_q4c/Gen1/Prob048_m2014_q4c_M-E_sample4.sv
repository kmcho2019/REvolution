module TopModule (
    input clk,
    input d,
    input r,
    output q
);

wire gated_d = r ? 1'b0 : d;
reg q_reg;

always @(posedge clk) begin
    q_reg <= gated_d;
end

assign q = q_reg;

endmodule