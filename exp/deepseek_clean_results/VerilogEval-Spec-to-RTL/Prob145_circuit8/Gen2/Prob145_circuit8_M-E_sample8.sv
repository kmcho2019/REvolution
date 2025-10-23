module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// p is set only when both clock and a are high
always @(posedge clock) begin
    p <= a;
end

// q captures p's value on negative clock edges
always @(negedge clock) begin
    q <= p;
end

// Initialize outputs to undefined (matching waveform)
initial begin
    p = 1'bx;
    q = 1'bx;
end

endmodule