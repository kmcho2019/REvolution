module TopModule(
    input       clock,
    input       a,
    output reg  p,
    output reg  q
);

    // On rising edge of clock, update p based on input a and current q
    always @(posedge clock) begin
        // According to waveform, p is set to 1 when a=1 at clock high, else 0
        // Also, p stays 1 at times when a=1 and clock=1
        // From waveform: p = a && some previous condition (e.g., q)
        // But checking waveform, p is 1 at clock=1 when a=1; else 0
        // So p <= a; but q is needed for state, so use p <= a for simplicity.
        // However, at 90ns (clock=1, a=1), p=1, at 95ns (clock=1, a=0), p=0.
        // So p tracks a at clock high.
        p <= a;
    end

    // On falling edge of clock, update q based on current p
    always @(negedge clock) begin
        // q follows previous p on falling edge (delayed)
        q <= p;
    end

endmodule