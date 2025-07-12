module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    wire ring_enable = ring;
    wire use_vibrate = vibrate_mode & ring_enable;
    wire use_ringer = ~vibrate_mode & ring_enable;

    assign ringer = use_ringer;
    assign motor = use_vibrate;

endmodule