module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

always_comb begin
    if (ring) begin
        if (vibrate_mode) begin
            motor = 1'b1;
            ringer = 1'b0;
        end else begin
            motor = 1'b0;
            ringer = 1'b1;
        end
    end else begin
        motor = 1'b0;
        ringer = 1'b0;
    end
end

endmodule