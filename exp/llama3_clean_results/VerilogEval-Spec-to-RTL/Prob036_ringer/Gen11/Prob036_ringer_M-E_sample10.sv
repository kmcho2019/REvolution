module TopModule(
    input logic ring,
    input logic vibrate_mode,
    output logic ringer,
    output logic motor
);

enum logic [1:0] {IDLE, RINGING, VIBRATING} state, nextState;

always_comb begin
    case(state)
        IDLE: begin
            if (ring) begin
                if (vibrate_mode)
                    nextState = VIBRATING;
                else
                    nextState = RINGING;
            end else begin
                nextState = IDLE;
            end
        end
        RINGING: begin
            if (!ring)
                nextState = IDLE;
            else
                nextState = RINGING;
        end
        VIBRATING: begin
            if (!ring)
                nextState = IDLE;
            else
                nextState = VIBRATING;
        end
        default: nextState = IDLE;
    endcase
end

always_ff @(posedge ring or posedge vibrate_mode) begin
    state <= nextState;
    case(state)
        IDLE: begin
            ringer <= 0;
            motor <= 0;
        end
        RINGING: begin
            ringer <= 1;
            motor <= 0;
        end
        VIBRATING: begin
            ringer <= 0;
            motor <= 1;
        end
        default: begin
            ringer <= 0;
            motor <= 0;
        end
    endcase
end

initial begin
    state = IDLE;
end

endmodule