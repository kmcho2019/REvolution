// Module TopModule: controls a cellphone's ringer and vibration motor
module TopModule(
    input ring,  // input signal indicating an incoming call
    input vibrate_mode,  // input signal indicating vibrate mode
    output ringer,  // output signal controlling the ringer
    output motor  // output signal controlling the vibration motor
);

    // Conditional logic to control the ringer and motor
    // The ringer is turned on when the phone is not in vibrate mode and the ring input is high
    // The motor is turned on when the phone is in vibrate mode and the ring input is high
    assign motor = ring & vibrate_mode;  // turn on motor when ring and vibrate_mode are high
    assign ringer = ring & ~vibrate_mode;  // turn on ringer when ring is high and vibrate_mode is low

endmodule