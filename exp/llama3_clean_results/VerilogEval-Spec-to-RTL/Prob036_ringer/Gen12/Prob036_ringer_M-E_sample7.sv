module TopModule(
    input  ring,
    input  vibrate_mode,
    output reg ringer,
    output reg motor
);

    reg [1:0] state;

    always @(*) begin
        case (state)
            2'b00: // Idle state
                begin
                    if (ring) begin
                        state = 2'b01; // Transition to ringing state
                    end
                    ringer = 0;
                    motor = 0;
                end
            2'b01: // Ringing state
                begin
                    if (vibrate_mode) begin
                        motor = 1;
                        ringer = 0;
                    end else begin
                        motor = 0;
                        ringer = 1;
                    end
                    if (!ring) begin
                        state = 2'b00; // Transition back to idle state
                    end
                end
            default: // Invalid state, reset to idle
                begin
                    state = 2'b00;
                    ringer = 0;
                    motor = 0;
                end
        endcase
    end

    initial begin
        state = 2'b00; // Initialize to idle state
    end

endmodule