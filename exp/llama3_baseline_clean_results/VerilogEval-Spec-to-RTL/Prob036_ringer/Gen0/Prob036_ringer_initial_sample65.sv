module TopModule(ring, vibrate_mode, ringer, motor);
    input ring;
    input vibrate_mode;
    output ringer;
    output motor;

    assign ringer = ring & ~vibrate_mode;
    assign motor = ring & vibrate_mode;

endmodule