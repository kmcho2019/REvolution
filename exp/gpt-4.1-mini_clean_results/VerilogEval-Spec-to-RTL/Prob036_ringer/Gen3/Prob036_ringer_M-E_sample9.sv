module TopModule(
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    wire [1:0] signals;
    // signals[1] = motor, signals[0] = ringer
    assign signals = ring ? {vibrate_mode, ~vibrate_mode} : 2'b00;

    assign motor = signals[1];
    assign ringer = signals[0];

endmodule