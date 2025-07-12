module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output reg  ringer,
    output reg  motor
);

    reg motor_sel, ringer_sel;

    always @(*) begin
        motor_sel  = ring & vibrate_mode;
        ringer_sel = ring & ~vibrate_mode;

        motor  = motor_sel;
        ringer = ringer_sel;
    end

endmodule