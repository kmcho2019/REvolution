module TopModule(
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

always @(*) begin
    if (ring) begin
        ringer = ~vibrate_mode;
        motor = vibrate_mode;
    end else begin
        ringer = 0;
        motor = 0;
    end
end

endmodule