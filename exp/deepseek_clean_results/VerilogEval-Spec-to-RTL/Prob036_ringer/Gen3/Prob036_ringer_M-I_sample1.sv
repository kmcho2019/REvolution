module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

    always @(*) begin
        case ({ring, vibrate_mode})
            2'b10: begin ringer = 1; motor = 0; end    // Ring only
            2'b11: begin ringer = 0; motor = 1; end    // Ring + vibrate mode
            default: begin ringer = 0; motor = 0; end  // No ring
        endcase
    end

endmodule