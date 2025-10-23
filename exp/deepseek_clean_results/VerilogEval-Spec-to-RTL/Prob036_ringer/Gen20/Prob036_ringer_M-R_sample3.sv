module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

    always @(*) begin
        case ({ring, vibrate_mode})
            2'b10: begin // Ringing, not in vibrate mode
                ringer = 1'b1;
                motor  = 1'b0;
            end
            2'b11: begin // Ringing in vibrate mode
                ringer = 1'b0;
                motor  = 1'b1;
            end
            default: begin // Not ringing
                ringer = 1'b0;
                motor  = 1'b0;
            end
        endcase
    end

endmodule