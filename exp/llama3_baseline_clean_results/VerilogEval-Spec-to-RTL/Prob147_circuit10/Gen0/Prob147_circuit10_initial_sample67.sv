module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;

always @(posedge clk) begin
    if (a == 0 && b == 0) begin
        state_reg <= 0;
    end else if (a == 0 && b == 1) begin
        state_reg <= ~state_reg;
    end else if (a == 1 && b == 0) begin
        state_reg <= state_reg;
    end else if (a == 1 && b == 1) begin
        state_reg <= ~state_reg;
    end
end

assign q = b || state_reg;

endmodule