module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;

always @(posedge clk) begin
    if (a & b) begin
        state_reg <= ~state_reg;
    end
    // else maintain state
end

assign q = a ? state_reg : (state_reg ^ b);
assign state = state_reg;

endmodule