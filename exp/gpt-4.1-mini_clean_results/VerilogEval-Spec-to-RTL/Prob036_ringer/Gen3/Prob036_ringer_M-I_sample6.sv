module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

wire [1:0] outputs;

assign outputs = ring ? {vibrate_mode, ~vibrate_mode} : 2'b00;

assign motor  = outputs[1];
assign ringer = outputs[0];

endmodule