module TopModule(
    input logic ring,
    input logic vibrate_mode,
    output logic ringer,
    output logic motor
);

always_comb begin
    ringer = ring ? !vibrate_mode : 1'b0;
    motor = ring ? vibrate_mode : 1'b0;
end

endmodule