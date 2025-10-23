module TopModule(
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

assign ringer = ring & ~vibrate_mode;
assign motor = ring & vibrate_mode;

// Alternatively, using a multiplexer approach:
// assign ringer = ~vibrate_mode ? ring : 0;
// assign motor = vibrate_mode ? ring : 0;

// Or more explicitly with a MUX:
// assign ringer = (vibrate_mode == 0) ? ring : 0;
// assign motor = (vibrate_mode == 1) ? ring : 0;

endmodule