module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State update logic - toggles when either:
// 1. Both a and b are high, OR
// 2. a is high and current state is low
always @(posedge clk) begin
    if ((a & b) || (a & ~state_reg)) begin
        state_reg <= ~state_reg;
    end
end

// Output logic - q is high when:
// (state is high AND b is low) OR (state is low AND b is high)
assign q = (state_reg & ~b) | (~state_reg & b);
assign state = state_reg;

endmodule