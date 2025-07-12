module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

enum logic [1:0] {IDLE, RINGING} state, next_state;

always_comb begin
    case(state)
        IDLE: next_state = ring ? RINGING : IDLE;
        RINGING: next_state = ring ? RINGING : IDLE;
    endcase
end

always_ff @(posedge ring or negedge ring) begin
    if (ring) begin
        state <= next_state;
    end
end

always_comb begin
    case(state)
        IDLE: begin
            ringer <= 0;
            motor <= 0;
        end
        RINGING: begin
            ringer <= ~vibrate_mode;
            motor <= vibrate_mode;
        end
    endcase
end

endmodule