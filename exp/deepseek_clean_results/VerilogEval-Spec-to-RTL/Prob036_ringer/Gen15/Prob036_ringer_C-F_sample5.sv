module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

    always @(*) begin
        // Default case - both outputs off
        ringer = 0;
        motor = 0;
        
        if (ring) begin
            case (vibrate_mode)
                1'b0: ringer = 1;  // Normal mode - ring
                1'b1: motor = 1;   // Vibrate mode - motor
            endcase
        end
    end

endmodule