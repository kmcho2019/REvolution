module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

always_comb begin
    ringer = ring? ~vibrate_mode : 0;
    motor = ring? vibrate_mode : 0;
end

endmodule