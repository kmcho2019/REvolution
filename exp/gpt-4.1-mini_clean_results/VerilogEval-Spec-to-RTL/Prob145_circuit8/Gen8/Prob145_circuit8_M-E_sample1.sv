module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Start with uninitialized states by not initializing p, q explicitly
// Implement next-state logic on clock rising edge to mimic waveform

always @(posedge clock) begin
    // Compute next p
    // Set p when a is 1 and q is 0, or keep p when a is 0 and p is 1
    p <= (a & ~q) | (p & ~a);

    // q follows previous p (delayed by one clock) but only sets after p is 1,
    // and holds when p resets
    q <= p;
end

endmodule