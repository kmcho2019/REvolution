module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;

// Next state logic: toggle when both a and b are 1, else maintain state
wire next_state = (a & b) ? ~state_reg : state_reg;

// Output logic: q is b XOR state (matches all cases in waveform)
assign q = b ^ state_reg;

always @(posedge clk) begin
    state_reg <= next_state;
end

assign state = state_reg;

endmodule