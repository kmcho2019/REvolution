// Module TopModule: controls a cellphone's ringer and vibration motor
module TopModule(
    input ring,  // input signal indicating an incoming call
    input vibrate_mode,  // input signal indicating vibrate mode
    output logic ringer,  // output signal controlling the ringer
    output logic motor  // output signal controlling the vibration motor
);

    // Conditional logic to control the ringer and motor
    // The ringer is turned on when the phone is not in vibrate mode and the ring input is high
    // The motor is turned on when the phone is in vibrate mode and the ring input is high
    // Using a concise conditional logic with the ternary operator
    assign motor = ring ? vibrate_mode : 0;  // turn on motor when ring is high and vibrate_mode is high
    assign ringer = ring ? !vibrate_mode : 0;  // turn on ringer when ring is high and vibrate_mode is low

    // This design is efficient in terms of Power, Performance, and Area (PPA) metrics
    // The use of the assign statement and ternary operator minimizes the logic required
    // The conditional logic is straightforward and easy to understand
    // The design does not contain any redundant or unnecessary logic

endmodule