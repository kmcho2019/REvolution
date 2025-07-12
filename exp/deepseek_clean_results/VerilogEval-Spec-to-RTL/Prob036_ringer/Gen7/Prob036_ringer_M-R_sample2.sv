module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

    always @(*) begin
        case ({ring, vibrate_mode})
            2'b10: begin
                ringer = 1'b1;
                motor = 1'b0;
            end
            2'b11: begin
                ringer = 1'b0;
                motor = 1'b1;
            end
            default: begin
                ringer = 1'b0;
                motor = 1'b0;
            end
        endcase
    end

endmodule