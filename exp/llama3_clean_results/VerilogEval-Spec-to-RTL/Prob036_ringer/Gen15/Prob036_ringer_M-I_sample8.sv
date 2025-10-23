module TopModule(
    input logic ring,
    input logic vibrate_mode,
    output logic ringer,
    output logic motor
);

// Using wire declaration for intermediate signals
wire logic ring_vibrate_mode;
wire logic ring_not_vibrate_mode;

always_comb begin
    // Calculate intermediate signals
    ring_vibrate_mode = ring && vibrate_mode;
    ring_not_vibrate_mode = ring && ~vibrate_mode;
    
    // Assign outputs based on intermediate signals
    ringer = ring_not_vibrate_mode;
    motor = ring_vibrate_mode;
end

endmodule