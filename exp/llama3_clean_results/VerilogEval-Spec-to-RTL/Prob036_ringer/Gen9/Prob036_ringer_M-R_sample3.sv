// Module TopModule: controls a cellphone's ringer and vibration motor
module TopModule(
    input ring,  // input signal indicating an incoming call
    input vibrate_mode,  // input signal indicating vibrate mode
    output reg ringer,  // output signal controlling the ringer
    output reg motor  // output signal controlling the vibration motor
);

    // Continuous assignments for motor and ringer
    assign motor = ring? vibrate_mode : 0;
    assign ringer = ring? ~vibrate_mode : 0;

endmodule