module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);
    // Combined approach: explicit selection with compact assignment
    assign {ringer, motor} = ring ? {~vibrate_mode, vibrate_mode} : 2'b00;
endmodule