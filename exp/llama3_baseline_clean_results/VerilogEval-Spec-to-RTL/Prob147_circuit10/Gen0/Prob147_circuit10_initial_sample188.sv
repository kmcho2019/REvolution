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
    if (a && b) begin
        state_reg <= 1'b1;
    end else if (!a && !b) begin
        // No change
    end else if (a && !b) begin
        state_reg <= ~state_reg;
    end else if (!a && b) begin
        // If b is 1 and a is 0, set state to 0
        state_reg <= 1'b0;
    end
end

assign q = (b) ? ~state : state;

endmodule