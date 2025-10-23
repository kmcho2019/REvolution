module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

reg next_state;

always @(*) begin
    // next_state logic from waveform analysis
    if (a == 1'b0 && b == 1'b1)
        next_state = 1'b1;
    else if (a == 1'b1 && b == 1'b1)
        next_state = 1'b0;
    else
        next_state = state; // hold state
end

always @(posedge clk) begin
    state <= next_state;
    q <= next_state ^ (a & b);
end

endmodule