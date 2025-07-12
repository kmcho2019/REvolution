module TopModule(
    input wire ring,
    input wire vibrate_mode,
    output wire ringer,
    output wire motor
);

wire ring_enable = ring;
wire motor_sel = vibrate_mode & ring_enable;
wire ringer_sel = ~vibrate_mode & ring_enable;

assign motor  = motor_sel;
assign ringer = ringer_sel;

endmodule