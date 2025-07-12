module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;

always @(posedge clk) begin
    state_reg <= (a & (~b)) | (~a & state_reg);
end

assign state = state_reg;
assign q = b | (~a & state);

endmodule