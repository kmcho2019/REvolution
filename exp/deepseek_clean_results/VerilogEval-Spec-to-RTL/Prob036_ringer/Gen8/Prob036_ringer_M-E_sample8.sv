module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);
    // Internal enable signal
    wire ring_enabled = ring;

    // Priority-based output assignment
    assign ringer = ring_enabled & ~vibrate_mode;
    assign motor  = ring_enabled & vibrate_mode;

    // Formal verification assertion for mutual exclusivity
    // synthesis translate_off
    always @(*) begin
        if (ringer && motor) $error("Mutual exclusivity violation");
    end
    // synthesis translate_on
endmodule