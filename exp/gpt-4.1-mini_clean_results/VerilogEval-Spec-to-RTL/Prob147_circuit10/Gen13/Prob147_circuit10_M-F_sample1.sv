module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg state,
    output reg q
);

reg next_state;

// Initialize state to 0 at simulation start to match waveform initial state
initial begin
    state = 0;
end

// Sequential logic: update state on positive edge of clk
always @(posedge clk) begin
    if (b)
        state <= a ^ state;
    else
        state <= state;
end

// Combinational logic for output q
always @(*) begin
    if (b)
        q = a;
    else
        q = state;
end

endmodule