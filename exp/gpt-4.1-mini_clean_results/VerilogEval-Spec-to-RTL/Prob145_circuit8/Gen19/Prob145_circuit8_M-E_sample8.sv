module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// Initialize p and q to unknown (x) to match waveform start
initial begin
    p = 1'bx;
    q = 1'bx;
end

// On rising edge of clock: p follows input 'a'
always @(posedge clock) begin
    p <= a;
end

// On falling edge of clock: q captures current p
always @(negedge clock) begin
    q <= p;
end

endmodule