module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

always @(*) begin
    if (ring) begin
        case (vibrate_mode)
            1'b0: {ringer, motor} = 2'b10;  // Normal mode - ring
            1'b1: {ringer, motor} = 2'b01;  // Vibrate mode - motor
        endcase
    end
    else begin
        {ringer, motor} = 2'b00;  // No ring - both off
    end
end

endmodule