// Module TopModule: controls a cellphone's ringer and vibration motor
module TopModule(
    input ring,  // input signal indicating an incoming call
    input vibrate_mode,  // input signal indicating vibrate mode
    output logic ringer,  // output signal controlling the ringer
    output logic motor  // output signal controlling the vibration motor
);

// Use an always block to assign values to the outputs based on the input conditions
always @(*) begin
    // Conditional logic to control the ringer and motor
    // The ringer is turned on when the phone is not in vibrate mode and the ring input is high
    // The motor is turned on when the phone is in vibrate mode and the ring input is high
    if (ring) begin
        ringer = ~vibrate_mode;  // turn on ringer when ring is high and vibrate_mode is low
        motor = vibrate_mode;  // turn on motor when ring and vibrate_mode are high
    end else begin
        ringer = 1'b0;  // turn off ringer when ring is low
        motor = 1'b0;  // turn off motor when ring is low
    end
end

endmodule