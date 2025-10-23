module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_latched;

initial begin
    p = 1'bx;  // Reflect unknown initial state as per waveform
    q = 1'bx;
    a_latched = 1'bx;
end

always @(negedge clock) begin
    a_latched <= a;  // Sample input 'a' on falling edge of clock
end

always @(posedge clock) begin
    p <= a_latched;  // Update p from sampled input
    q <= p;          // q follows previous p (one clock delayed)
end

endmodule