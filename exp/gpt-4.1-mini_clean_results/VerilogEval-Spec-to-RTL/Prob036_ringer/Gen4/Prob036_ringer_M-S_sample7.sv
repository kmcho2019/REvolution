module TopModule(
    input  ring,
    input  vibrate_mode,
    output ringer,
    output motor
);

wire [1:0] out;
assign out = ring ? {vibrate_mode, ~vibrate_mode} : 2'b00;

assign ringer = out[0];
assign motor  = out[1];

endmodule