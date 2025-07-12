module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

logic ringer_enable, motor_enable;

assign ringer_enable = ring & ~vibrate_mode;
assign motor_enable = ring & vibrate_mode;

always_comb begin
    case (vibrate_mode)
        1'b0: begin
            ringer = ringer_enable;
            motor = 1'b0;
        end
        1'b1: begin
            ringer = 1'b0;
            motor = motor_enable;
        end
        default: begin
            ringer = 1'b0;
            motor = 1'b0;
        end
    endcase
end

endmodule