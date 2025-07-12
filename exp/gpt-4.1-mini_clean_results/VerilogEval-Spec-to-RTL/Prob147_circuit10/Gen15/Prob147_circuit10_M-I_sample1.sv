module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Next state logic derived from waveform analysis
assign next_state = (state & ~b) | (~state & a & b);

// Update state on positive edge of clk
always @(posedge clk) begin
    state <= next_state;
end

// Output logic derived from waveform analysis
assign q = (state & ~a) | (~state & b);

// Initialize state to 0 to match initial waveform condition
initial begin
    state = 1'b0;
end

endmodule