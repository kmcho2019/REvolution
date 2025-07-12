module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

wire [1:0] outputs;
assign outputs = {ring & vibrate_mode, ring & ~vibrate_mode}; // motor, ringer
assign motor  = outputs[1];
assign ringer = outputs[0];

endmodule