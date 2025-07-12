module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// One-hot combinational encoding of outputs (0: ringer, 1: motor)
wire [1:0] out_enc;

assign out_enc = {vibrate_mode, ~vibrate_mode}; // {motor, ringer}, mutually exclusive

// Gate outputs with ring to avoid toggling when no call
assign motor  = ring & out_enc[1];
assign ringer = ring & out_enc[0];

endmodule