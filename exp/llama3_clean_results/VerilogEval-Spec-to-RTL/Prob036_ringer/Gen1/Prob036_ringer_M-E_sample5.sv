module TopModule(
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

reg [1:0] state; // 0: IDLE, 1: RINGING_RINGER, 2: RINGING_MOTOR

always @(*) begin
    case(state)
        0: begin // IDLE
            if (ring) begin
                if (vibrate_mode) begin
                    state = 2; // RINGING_MOTOR
                end else begin
                    state = 1; // RINGING_RINGER
                end
            end
        end
        1: begin // RINGING_RINGER
            ringer = 1;
            motor = 0;
            if (!ring) begin
                state = 0; // IDLE
            end
        end
        2: begin // RINGING_MOTOR
            ringer = 0;
            motor = 1;
            if (!ring) begin
                state = 0; // IDLE
            end
        end
        default: begin
            state = 0; // IDLE
        end
    endcase
end

endmodule