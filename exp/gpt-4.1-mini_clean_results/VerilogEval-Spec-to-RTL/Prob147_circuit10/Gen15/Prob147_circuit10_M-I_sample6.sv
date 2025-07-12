module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

// next_state logic derived from waveform analysis
wire next_state;
assign next_state = (state & ~a & ~b) | (~state & a & ~b) | (state & a & b);

// output q logic matches waveform behavior
assign q = state | (~state & (a ^ b));

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule