module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State update logic - toggles when a and b differ
always @(posedge clk) begin
    if (a ^ b) begin
        state_reg <= ~state_reg;
    end
end

// Output logic - matches all waveform cases
assign q = (state_reg & ~b) | (~state_reg & a & b);
assign state = state_reg;

endmodule