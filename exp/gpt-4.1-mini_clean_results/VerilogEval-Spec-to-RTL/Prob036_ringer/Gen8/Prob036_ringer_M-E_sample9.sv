module TopModule(
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

wire [1:0] active_out;

assign active_out = ring ? (vibrate_mode ? 2'b01 : 2'b10) : 2'b00;

assign {ringer, motor} = active_out;

endmodule