module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

    always @(*) begin
        case ({ring, vibrate_mode})
            2'b10: begin  // ring=1, vibrate_mode=0
                ringer = 1;
                motor = 0;
            end
            2'b11: begin  // ring=1, vibrate_mode=1
                ringer = 0;
                motor = 1;
            end
            default: begin  // all other cases
                ringer = 0;
                motor = 0;
            end
        endcase
    end

endmodule