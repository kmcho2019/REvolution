module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;
assign q = state_reg;

always @(posedge clk) begin
    if (a && b) begin
        state_reg <= 0;
    end else if (!a && b) begin
        state_reg <= 0;
    end else if (a && !b) begin
        state_reg <= 1;
    end else if (!a && !b) begin
        // No change
    end
end

endmodule