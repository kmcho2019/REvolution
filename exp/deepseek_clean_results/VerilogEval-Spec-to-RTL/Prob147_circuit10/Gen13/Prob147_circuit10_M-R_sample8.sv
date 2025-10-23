module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;  // Initialize state to 0

// State transition (toggles when both a and b are high)
always @(posedge clk) begin
    if (a & b) begin
        state_reg <= ~state_reg;
    end
end

// Output logic
assign q = (state_reg & ~b) | (~state_reg & a & b);
assign state = state_reg;

endmodule