module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

enum logic [1:0] {IDLE, RINGING} state, next_state;

always_ff @(posedge ring or negedge ring) begin
    if (ring) begin
        state <= RINGING;
    end else begin
        state <= IDLE;
    end
end

always_comb begin
    case (state)
        IDLE: begin
            next_state = (ring) ? RINGING : IDLE;
            ringer = 0;
            motor = 0;
        end
        RINGING: begin
            next_state = (!ring) ? IDLE : RINGING;
            if (vibrate_mode) begin
                ringer = 0;
                motor = 1;
            end else begin
                ringer = 1;
                motor = 0;
            end
        end
        default: begin
            next_state = IDLE;
            ringer = 0;
            motor = 0;
        end
    endcase
end

endmodule