module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Ringer activates when ringing and NOT in vibrate mode
    assign ringer = ring & ~vibrate_mode;
    
    // Motor activates when ringing AND in vibrate mode
    assign motor = ring & vibrate_mode;

    // Note: Outputs are mutually exclusive by construction since:
    // - vibrate_mode and ~vibrate_mode cannot be true simultaneously
    // - Both outputs are ANDed with the same 'ring' signal
endmodule