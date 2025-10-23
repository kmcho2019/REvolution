module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// next_state logic derived from waveform:
// state sets to 1 if b=1 and a=0, or if a=1 and b=0,
// else retains if a=0 and b=0 and state=1,
// else resets to 0 when a=1 and b=1 or other conditions.
assign next_state = (b & ~a) | (a & ~b) | (state & ~a & ~b);

// output q logic:
// q=1 when (state=1 and NOT (a=1 and b=1)) or (state=0 and b=1)
assign q = (state & ~(a & b)) | (~state & b);

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule