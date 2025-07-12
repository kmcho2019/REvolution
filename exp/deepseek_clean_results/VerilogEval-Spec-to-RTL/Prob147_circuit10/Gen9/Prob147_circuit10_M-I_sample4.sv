module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;

always @(posedge clk) begin
    if (a) begin
        state_reg <= b ? ~state_reg : 1'b0;
    end
end

assign q = state_reg ^ b;
assign state = state_reg;

endmodule