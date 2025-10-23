module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// Initialize p and q to unknown (x) to match initial waveform state
initial begin
    p = 1'bx;
    q = 1'bx;
end

// p updates at rising edge of clock to input a
always @(posedge clock) begin
    p <= a;
end

// q updates at falling edge of clock to current p
always @(negedge clock) begin
    q <= p;
end

endmodule