module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

assign {motor, ringer} = ring ? (vibrate_mode ? 2'b10 : 2'b01) : 2'b00;

endmodule