module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

enum logic [1:0] {IDLE, RINGING} state, next_state;

always_comb begin
    case(state)
        IDLE: begin
            if (ring) next_state = RINGING;
            else next_state = IDLE;
        end
        RINGING: begin
            if (~ring) next_state = IDLE;
            else next_state = RINGING;
        end
        default: next_state = IDLE;
    endcase
end

always_ff @(posedge ring or negedge ring) begin
    case(state)
        IDLE: begin
            ringer = 0;
            motor = 0;
        end
        RINGING: begin
            if (vibrate_mode) motor = 1;
            else ringer = 1;
        end
        default: begin
            ringer = 0;
            motor = 0;
        end
    endcase
    state = next_state;
end

initial state = IDLE;

endmodule