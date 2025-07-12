module TopModule (
    input  ring,            // Incoming call signal
    input  vibrate_mode,    // Phone vibration mode setting
    output reg ringer,      // Ringer control output
    output reg motor        // Vibration motor control output
);

    always @(*) begin
        case ({ring, vibrate_mode})
            2'b10: begin    // Ringing, not in vibrate mode
                ringer = 1'b1;
                motor = 1'b0;
            end
            2'b11: begin    // Ringing in vibrate mode
                ringer = 1'b0;
                motor = 1'b1;
            end
            default: begin // Not ringing
                ringer = 1'b0;
                motor = 1'b0;
            end
        endcase
    end

endmodule