module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

enum logic [1:0] {IDLE, RINGING, VIBRATING} state, next_state;

always_comb begin
    case(state)
        IDLE: begin
            if(ring) begin
                if(vibrate_mode)
                    next_state = VIBRATING;
                else
                    next_state = RINGING;
            end else begin
                next_state = IDLE;
            end
        end
        RINGING: begin
            if(!ring)
                next_state = IDLE;
            else
                next_state = RINGING;
        end
        VIBRATING: begin
            if(!ring)
                next_state = IDLE;
            else
                next_state = VIBRATING;
        end
    endcase
end

always_ff @(posedge ring or negedge ring) begin
    state <= next_state;
end

always_comb begin
    case(state)
        IDLE: begin
            ringer = 0;
            motor = 0;
        end
        RINGING: begin
            ringer = 1;
            motor = 0;
        end
        VIBRATING: begin
            ringer = 0;
            motor = 1;
        end
    endcase
end

endmodule