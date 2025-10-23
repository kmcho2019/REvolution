module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

always_comb begin
    ringer = ~vibrate_mode && ring;
    motor = vibrate_mode && ring;
end

endmodule