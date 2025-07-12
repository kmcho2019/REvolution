`default_nettype none

module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

    // Internal one-hot encoded mode signal:
    // mode[1] = motor, mode[0] = ringer
    wire [1:0] mode;

    // Combinational logic to decide which output to activate
    // Only one bit active at a time when ring is asserted
    assign mode = ring ? (vibrate_mode ? 2'b10 : 2'b01) : 2'b00;

    assign ringer = mode[0];
    assign motor  = mode[1];

endmodule

`default_nettype wire