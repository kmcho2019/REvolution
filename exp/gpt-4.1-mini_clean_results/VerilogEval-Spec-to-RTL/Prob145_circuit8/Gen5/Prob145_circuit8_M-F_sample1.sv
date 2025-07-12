module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Initialize outputs to unknown to match initial 'x' states in waveform
initial begin
    p = 1'bx;
    q = 1'bx;
end

// On rising edge of clock, sample input 'a' into 'p'
always @(posedge clock) begin
    p <= a;
end

// On falling edge of clock, sample 'p' into 'q'
always @(negedge clock) begin
    q <= p;
end

endmodule