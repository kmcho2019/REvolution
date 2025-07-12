module TopModule(
    input  ring,
    input  vibrate_mode,
    output ringer,
    output motor
);

wire [1:0] ctrl;

// Encode output as 2-bit vector: bit0 = ringer, bit1 = motor
assign ctrl = ring ? {vibrate_mode, ~vibrate_mode} : 2'b00;

assign ringer = ctrl[0];
assign motor  = ctrl[1];

endmodule