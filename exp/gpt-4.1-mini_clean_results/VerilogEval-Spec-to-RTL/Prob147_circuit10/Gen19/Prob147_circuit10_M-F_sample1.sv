module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

reg next_state;

always @(*) begin
    // next_state logic derived from waveform analysis
    // next_state = (b & ~a) | (state & ~(a & b));
    next_state = (b & ~a) | (state & ~(a & b));
    
    // output q equals next_state
    q = next_state;
end

always @(posedge clk) begin
    state <= next_state;
end

endmodule