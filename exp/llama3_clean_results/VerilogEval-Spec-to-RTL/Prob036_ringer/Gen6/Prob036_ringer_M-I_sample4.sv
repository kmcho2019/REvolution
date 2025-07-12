module TopModule(
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

assign ringer = ring? ~vibrate_mode : 0;
assign motor = ring? vibrate_mode : 0;

endmodule