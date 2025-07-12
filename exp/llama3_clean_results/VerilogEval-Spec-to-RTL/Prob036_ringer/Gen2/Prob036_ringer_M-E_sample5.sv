module TopModule(
    input  ring,
    input  vibrate_mode,
    output ringer,
    output motor
);

    reg [1:0] state; // idle (0), ringing (1)

    always @(posedge ring or negedge ring) begin
        case (state)
            0: begin // idle state
                if (ring) begin
                    state <= 1; // transition to ringing state
                end
            end
            1: begin // ringing state
                if (!ring) begin
                    state <= 0; // transition back to idle state
                end
            end
            default: begin
                state <= 0; // default to idle state
            end
        endcase
    end

    always @(*) begin
        case (state)
            0: begin // idle state
                ringer <= 0;
                motor <= 0;
            end
            1: begin // ringing state
                if (vibrate_mode) begin
                    ringer <= 0;
                    motor <= 1;
                end else begin
                    ringer <= 1;
                    motor <= 0;
                end
            end
            default: begin
                ringer <= 0;
                motor <= 0;
            end
        endcase
    end

endmodule