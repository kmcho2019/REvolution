module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Use vibrate_mode as mux select
    assign ringer = ring & ~vibrate_mode;
    assign motor = ring & vibrate_mode;

    // Alternative implementation showing the mux concept
    // wire mux_out;
    // assign mux_out = vibrate_mode ? ring : ~ring;
    // assign ringer = ring & ~vibrate_mode;
    // assign motor = ring & vibrate_mode;

endmodule