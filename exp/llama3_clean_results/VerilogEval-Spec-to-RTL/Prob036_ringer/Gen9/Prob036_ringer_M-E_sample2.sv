module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

logic ringer_sig, motor_sig;

assign ringer_sig = ring;
assign motor_sig = ring;

always_comb begin
    case (vibrate_mode)
        1'b0: begin
            ringer = ringer_sig;
            motor = 1'b0;
        end
        1'b1: begin
            ringer = 1'b0;
            motor = motor_sig;
        end
    endcase
end

endmodule