module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;

always @(posedge clk) begin
    if (b == 1) begin
        state_reg <= ~a;
    end else begin
        state_reg <= state_reg;
    end
end

assign state = state_reg;
assign q = state_reg | a;

endmodule