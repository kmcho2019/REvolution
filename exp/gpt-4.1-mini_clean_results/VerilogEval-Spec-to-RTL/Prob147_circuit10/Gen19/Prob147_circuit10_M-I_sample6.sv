module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Next state logic based on waveform observation:
// next_state = (state & ~(a & ~b)) | (~state & b)
assign next_state = (state & (~(a & ~b))) | (~state & b);

// Output q equals next_state (from waveform behavior)
assign q = next_state;

always @(posedge clk) begin
    state <= next_state;
end

endmodule