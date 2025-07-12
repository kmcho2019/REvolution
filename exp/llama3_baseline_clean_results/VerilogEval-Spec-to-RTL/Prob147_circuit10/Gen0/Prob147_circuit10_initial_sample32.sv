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
    if (a && b) begin
        state_reg <= 0;
    end else if (!a && b) begin
        state_reg <= 1;
    end
end

assign q = (b) ? ~state_reg : state_reg;

endmodule