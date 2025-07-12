module TopModule(
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

always @(*) begin
    if (vibrate_mode) begin
        ringer = 0;
        motor = ring;
    end else begin
        ringer = ring;
        motor = 0;
    end
end

endmodule