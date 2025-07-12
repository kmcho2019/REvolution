module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    // On rising edge of clock, update p based on input a and current q
    always @(posedge clock) begin
        // From waveform: p <= a & q
        p <= a & q;
    end

    // On falling edge of clock, latch p into q
    always @(negedge clock) begin
        q <= p;
    end

endmodule