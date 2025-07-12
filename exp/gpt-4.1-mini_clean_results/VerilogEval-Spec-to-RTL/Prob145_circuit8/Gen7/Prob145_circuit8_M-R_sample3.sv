module TopModule(
    input clock,
    input a,
    output p,
    output q
);

// Internal registers representing the state
reg state_p;
reg state_q;

// Initialize state to unknown (x) to match waveform initial conditions
initial begin
    state_p = 1'bx;
    state_q = 1'bx;
end

// Sequential state update at the rising edge of clock
always @(posedge clock) begin
    state_q <= state_p;
    state_p <= a;
end

// Continuous assignments for outputs from internal state
assign p = state_p;
assign q = state_q;

endmodule