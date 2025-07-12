module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

always_comb begin
    {ringer, motor} = ring ? {~vibrate_mode, vibrate_mode} : 2'b00;
end

endmodule