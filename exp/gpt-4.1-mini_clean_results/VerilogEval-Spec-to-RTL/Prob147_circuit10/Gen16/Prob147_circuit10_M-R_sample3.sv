module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

reg next_state;

always @* begin
    // Next state logic deduced from waveform:
    // next_state = (state OR b) AND NOT (a AND b)
    next_state = (state | b) & ~(a & b);

    // Output logic deduced:
    // q = a XOR b XOR state
    q = a ^ b ^ state;
end

always @(posedge clk) begin
    state <= next_state;
end

endmodule