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
    if (a == 1 && b == 1) begin
        state_reg <= 0;
    end else if (a == 0 && b == 0 && state_reg == 1) begin
        state_reg <= 1;
    end else if (a == 0 && b == 1) begin
        state_reg <= 0;
    end else if (a == 1 && b == 0 && state_reg == 1) begin
        state_reg <= 0;
    end
end

assign q = (a == 0 && b == 1) || (a == 1 && b == 0 && state_reg == 0) || (state_reg == 1 && a == 0 && b == 0);

endmodule