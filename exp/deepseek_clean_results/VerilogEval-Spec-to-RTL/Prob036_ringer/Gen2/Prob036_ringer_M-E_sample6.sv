module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Use vibrate_mode as select for a mux that routes ring to either ringer or motor
    assign ringer = ring & ~vibrate_mode;
    assign motor = ring & vibrate_mode;

    // Alternative implementation showing the mux concept more explicitly
    // wire ring_to_output;
    // assign ring_to_output = vibrate_mode ? motor : ringer;
    // assign ring_to_output = ring;
    // But this requires different output handling so keeping original implementation

endmodule