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

// Alternative multiplexer-based implementation
// assign ringer = ~vibrate_mode? ring : 1'b0;
// assign motor = vibrate_mode? ring : 1'b0;

endmodule