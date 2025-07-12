module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);
    always @(*) begin
        case (vibrate_mode)
            1'b1: begin  // Vibrate mode
                ringer = 1'b0;
                motor  = ring;
            end
            1'b0: begin  // Normal mode
                ringer = ring;
                motor  = 1'b0;
            end
        endcase
    end
endmodule