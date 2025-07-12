module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Use a conceptual multiplexer structure
    assign {ringer, motor} = ring ? (vibrate_mode ? 2'b01 : 2'b10) : 2'b00;

endmodule