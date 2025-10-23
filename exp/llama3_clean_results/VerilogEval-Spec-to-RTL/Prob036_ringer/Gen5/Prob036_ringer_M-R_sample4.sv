// Module TopModule: controls a cellphone's ringer and vibration motor
module TopModule(
    input ring,  // input signal indicating an incoming call
    input vibrate_mode,  // input signal indicating vibrate mode
    output ringer,  // output signal controlling the ringer
    output motor  // output signal controlling the vibration motor
);

    // Directly control the ringer and motor outputs based on the ring and vibrate_mode inputs
    // This approach maintains efficiency and simplicity while ensuring the logic is straightforward
    assign motor = ring & vibrate_mode;  // Turn on the motor when the phone is ringing and in vibrate mode
    assign ringer = ring & ~vibrate_mode;  // Turn on the ringer when the phone is ringing and not in vibrate mode

endmodule