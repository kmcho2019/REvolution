module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output reg  ringer,
    output reg  motor
);

always @(*) begin
    ringer = 0;
    motor = 0;
    if (ring) begin
        if (vibrate_mode)
            motor = 1;
        else
            ringer = 1;
    end
end

endmodule