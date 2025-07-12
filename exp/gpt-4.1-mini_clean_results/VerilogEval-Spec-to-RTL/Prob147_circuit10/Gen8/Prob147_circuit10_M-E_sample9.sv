module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire ab_and = a & b;
wire next_state = state ^ ab_and;

// Output logic q derived combinationally from state,a,b to match waveform pattern
assign q = (state & ~a & b) | (~state & a & b) | (state & a & ~b);

// Sequential update of state
always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule