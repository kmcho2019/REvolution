module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;  // Initialize to match waveform

// State toggles when both inputs are high OR both are low
always @(posedge clk) begin
    if ((a & b) | (~a & ~b)) begin
        state_reg <= ~state_reg;
    end
end

// q = (b & ~state) OR (a & ~b) OR (a & b & state)
assign q = (b & ~state_reg) | (a & ~b) | (a & b & state_reg);

assign state = state_reg;

endmodule