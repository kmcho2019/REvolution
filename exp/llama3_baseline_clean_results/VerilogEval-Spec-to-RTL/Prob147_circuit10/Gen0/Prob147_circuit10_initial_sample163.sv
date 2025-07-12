module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;

always @(posedge clk) begin
    if (b == 1 && a == 1) begin
        state_reg <= 1;
    end else if (b == 1 && a == 0) begin
        state_reg <= 0;
    end else begin
        state_reg <= state_reg;
    end
end

assign q = (b == 0 && a == 1 && state_reg == 1) || (b == 1 && state_reg == 0);

endmodule