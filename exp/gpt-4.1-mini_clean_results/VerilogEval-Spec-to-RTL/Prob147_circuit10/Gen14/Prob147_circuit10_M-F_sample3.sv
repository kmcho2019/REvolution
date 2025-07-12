module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// next_state logic derived from waveform analysis
assign next_state = (state & ~a & ~b) | (~state & b) | (a & ~b & ~state);

// output q follows next_state except forced 0 when a=1 and b=1
assign q = next_state & ~(a & b);

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule