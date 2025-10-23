module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Next state logic:
// If current state is 1 and a=1 and b=1, go to 0
// Else if state=0 and b=1, go to 1
// Otherwise hold current state
assign next_state = (state & ~(a & b)) | (~state & b);

// Output q equals next state (as per waveform)
assign q = next_state;

always @(posedge clk) begin
    state <= next_state;
end

endmodule