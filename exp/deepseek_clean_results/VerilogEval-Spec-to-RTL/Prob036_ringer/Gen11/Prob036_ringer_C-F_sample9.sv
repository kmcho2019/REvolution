module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);
    assign {ringer, motor} = {ring & ~vibrate_mode, ring & vibrate_mode};
endmodule