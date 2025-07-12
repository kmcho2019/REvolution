module TopModule(
    input logic ring,
    input logic vibrate_mode,
    output logic ringer,
    output logic motor
);

typedef enum logic [1:0] {IDLE, ALERT_RINGER, ALERT_MOTOR} state_t;

state_t current_state, next_state;

always_comb begin
    case (current_state)
        IDLE: begin
            if (ring) begin
                if (vibrate_mode) begin
                    next_state = ALERT_MOTOR;
                end else begin
                    next_state = ALERT_RINGER;
                end
            end else begin
                next_state = IDLE;
            end
        end
        ALERT_RINGER: begin
            if (!ring) begin
                next_state = IDLE;
            end else begin
                next_state = ALERT_RINGER;
            end
        end
        ALERT_MOTOR: begin
            if (!ring) begin
                next_state = IDLE;
            end else begin
                next_state = ALERT_MOTOR;
            end
        end
        default: next_state = IDLE;
    endcase
end

always_ff @(posedge ring or negedge ring) begin
    current_state <= next_state;
end

always_comb begin
    case (current_state)
        IDLE: begin
            ringer = 0;
            motor = 0;
        end
        ALERT_RINGER: begin
            ringer = 1;
            motor = 0;
        end
        ALERT_MOTOR: begin
            ringer = 0;
            motor = 1;
        end
        default: begin
            ringer = 0;
            motor = 0;
        end
    endcase
end

initial begin
    current_state = IDLE;
end

endmodule