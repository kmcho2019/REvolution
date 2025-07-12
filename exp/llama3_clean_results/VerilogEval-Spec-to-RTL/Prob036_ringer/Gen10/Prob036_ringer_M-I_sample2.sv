// Module TopModule: controls a cellphone's ringer and vibration motor
module TopModule(
    input ring,  // input signal indicating an incoming call
    input vibrate_mode,  // input signal indicating vibrate mode
    output reg ringer,  // output signal controlling the ringer
    output reg motor  // output signal controlling the vibration motor
);

    // Combinational logic to control the ringer and motor
    // The ringer is turned on when the phone is not in vibrate mode and the ring input is high
    // The motor is turned on when the phone is in vibrate mode and the ring input is high
    always @(*) begin
        motor = ring & vibrate_mode;
        ringer = ring & ~vibrate_mode;
    end

endmodule