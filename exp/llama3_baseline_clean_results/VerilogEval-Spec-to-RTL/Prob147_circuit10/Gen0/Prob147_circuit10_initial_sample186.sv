module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;
assign q = ~state_reg ^ b;

always @ (posedge clk) begin
    if (~a) begin
        state_reg <= ~state_reg;
    end else begin
        state_reg <= 0;
    end
end

endmodule