module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Pre-compute both possible output states
    wire ringer_option = ring & ~vibrate_mode;
    wire motor_option  = ring & vibrate_mode;

    // Use vibrate_mode as mux select to choose between modes
    assign ringer = vibrate_mode ? 1'b0 : ringer_option;
    assign motor  = vibrate_mode ? motor_option : 1'b0;

endmodule