module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

logic ringer_enable, motor_enable;

assign ringer_enable = ~vibrate_mode;
assign motor_enable = vibrate_mode;

always_comb begin
    if (ring) begin
        ringer = ringer_enable;
        motor = motor_enable;
    end else begin
        ringer = 0;
        motor = 0;
    end
end

endmodule