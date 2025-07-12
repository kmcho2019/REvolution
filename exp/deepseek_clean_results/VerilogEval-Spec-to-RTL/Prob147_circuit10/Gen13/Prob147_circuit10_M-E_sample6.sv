module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State update logic - toggles when both a and b are high
always @(posedge clk) begin
    if (a & b) begin
        state_reg <= ~state_reg;
    end
end

// Output logic - q is high when:
// (b is high and state is low) OR (a is high and state is high)
assign q = (b & ~state_reg) | (a & state_reg);
assign state = state_reg;

endmodule