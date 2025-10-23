module TopModule(
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    always @(ring, vibrate_mode) begin
        if (vibrate_mode) begin
            motor = ring;
            ringer = 0;
        end else begin
            motor = 0;
            ringer = ring;
        end
    end

endmodule