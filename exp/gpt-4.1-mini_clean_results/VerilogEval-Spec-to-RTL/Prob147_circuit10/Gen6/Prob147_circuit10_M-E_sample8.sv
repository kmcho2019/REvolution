module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

// Next state logic:
// When b=1 and a=0, set state to 1
// When b=1 and a=1, toggle state
// When b=0, hold state (no explicit reset seen in waveform)
wire next_state;
assign next_state = (state ^ (a & b)) | (b & ~a);

// Output logic: q is high if state is high or both a and b are high
assign q = state | (a & b);

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule