module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

    always @(*) begin
        // Default outputs
        ringer = 0;
        motor = 0;
        
        // Priority encoding
        case ({ring, vibrate_mode})
            2'b10: ringer = 1;    // Ring only
            2'b11: motor = 1;     // Ring + vibrate mode
            default: ;            // No action for other cases
        endcase
    end

endmodule