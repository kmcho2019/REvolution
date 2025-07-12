module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

// Next state logic
reg next_state;

always @(*) begin
    if (~a & ~b)
        next_state = 1'b0;        // reset
    else if (~a & b)
        next_state = 1'b1;        // set
    else if (a & b)
        next_state = ~state;      // toggle
    else // a=1,b=0
        next_state = state;       // hold
end

// Output logic refined per waveform
assign q = (state & ~b) | (~state & b & a);

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule