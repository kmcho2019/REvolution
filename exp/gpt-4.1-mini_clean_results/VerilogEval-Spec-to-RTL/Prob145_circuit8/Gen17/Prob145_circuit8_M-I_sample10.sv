module TopModule(
    input  clock,
    input  a,
    output reg p,
    output reg q
);

    // Initialize outputs to unknown to match initial waveform states
    initial begin
        p = 1'bx;
        q = 1'bx;
    end

    // On rising edge of clock, sample input 'a' to 'p'
    always @(posedge clock) begin
        p <= a;
    end

    // On falling edge of clock, latch current 'p' to 'q', introducing half-cycle delay
    always @(negedge clock) begin
        q <= p;
    end

endmodule