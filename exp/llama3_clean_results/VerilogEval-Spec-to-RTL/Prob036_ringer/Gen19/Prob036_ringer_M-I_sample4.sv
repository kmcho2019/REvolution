module TopModule(
    input logic ring,
    input logic vibrate_mode,
    output logic ringer,
    output logic motor
);

always_comb begin
    ringer = ring & ~vibrate_mode; // Using bitwise AND for better readability and efficiency
    motor = ring & vibrate_mode;
end

endmodule