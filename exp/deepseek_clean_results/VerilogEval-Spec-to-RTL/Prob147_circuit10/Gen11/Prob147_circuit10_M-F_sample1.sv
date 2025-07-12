module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State update logic - toggles when a != b
always @(posedge clk) begin
    if (a ^ b) begin
        state_reg <= ~state_reg;
    end
end

// Output logic - q is 1 when (state & ~b) or (~state & a & b)
assign q = (state_reg & ~b) | (~state_reg & a & b);
assign state = state_reg;

endmodule