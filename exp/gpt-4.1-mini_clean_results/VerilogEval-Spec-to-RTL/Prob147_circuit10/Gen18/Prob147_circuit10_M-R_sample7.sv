module TopModule(
    input clk,
    input a,
    input b,
    output state,
    output q
);

reg state_reg;
wire next_state;
wire q_wire;

// Next state logic from waveform analysis:
// state=0 -> next_state=1 if a=1 & b=0, else 0
// state=1 -> next_state=0 if (a=1 & b=1) or (a=0 & b=0), else 1
assign next_state = (state_reg == 1'b0) ? (a & ~b) : (~( (a & b) | (~a & ~b) ));

// Output logic q from waveform analysis:
// When state=1, q=1 except when a=1 and b=1 (q=0)
// When state=0, q=1 only when a=1 and b=1, else 0
assign q_wire = (state_reg) ? (~(a & b)) : (a & b);

// Sequential update of state flip-flop
always @(posedge clk) begin
    state_reg <= next_state;
end

// Expose the state and q outputs
assign state = state_reg;
assign q = q_wire;

// Initialize state to 0 (no reset input specified)
initial begin
    state_reg = 1'b0;
end

endmodule