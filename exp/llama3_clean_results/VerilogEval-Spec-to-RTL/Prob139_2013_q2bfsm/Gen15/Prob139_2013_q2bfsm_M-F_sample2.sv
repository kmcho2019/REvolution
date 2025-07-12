module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

typedef enum {RESET, PULSE_F, DETECT_SEQ_1, DETECT_SEQ_2, DETECT_SEQ_3, MONITOR_Y_1, MONITOR_Y_2, G_HIGH, G_LOW} state_t;

state_t state, next_state;

always @ (*) begin
    case (state)
        RESET: begin
            if (resetn) begin
                next_state = PULSE_F;
            end else begin
                next_state = RESET;
            end
        end
        PULSE_F: begin
            next_state = DETECT_SEQ_1;
        end
        DETECT_SEQ_1: begin
            if (x) begin
                next_state = DETECT_SEQ_2;
            end else begin
                next_state = DETECT_SEQ_1;
            end
        end
        DETECT_SEQ_2: begin
            if (!x) begin
                next_state = DETECT_SEQ_3;
            end else begin
                next_state = DETECT_SEQ_1;
            end
        end
        DETECT_SEQ_3: begin
            if (x) begin
                next_state = MONITOR_Y_1;
            end else begin
                next_state = DETECT_SEQ_1;
            end
        end
        MONITOR_Y_1: begin
            if (y) begin
                next_state = G_HIGH;
            end else begin
                next_state = MONITOR_Y_2;
            end
        end
        MONITOR_Y_2: begin
            if (y) begin
                next_state = G_HIGH;
            end else begin
                next_state = G_LOW;
            end
        end
        G_HIGH: begin
            next_state = G_HIGH;
        end
        G_LOW: begin
            next_state = G_LOW;
        end
    endcase
end

always @ (posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        case (state)
            PULSE_F: begin
                f <= 1;
            end
            default: begin
                f <= 0;
            end
        endcase
        case (next_state)
            G_HIGH: begin
                g <= 1;
            end
            G_LOW: begin
                g <= 0;
            end
            default: begin
                g <= g; // Hold previous value
            end
        endcase
    end
end

endmodule