module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

wire call_active;
wire vibrate_active;

assign call_active    = ring;
assign vibrate_active = vibrate_mode & call_active;

assign motor  = vibrate_active;
assign ringer = call_active & ~vibrate_mode;

endmodule