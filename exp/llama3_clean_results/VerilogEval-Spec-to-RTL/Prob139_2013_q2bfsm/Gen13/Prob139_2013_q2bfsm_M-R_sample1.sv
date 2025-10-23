module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

typedef enum {RESET, PULSE_F, DETECT_SEQ, DETECT_Y, G_HIGH} state_t;

state_t state, next_state;

reg [1:0] x_count;
reg [1:0] y_count;

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
            next_state = DETECT_SEQ;
        end
        DETECT_SEQ: begin
            if (x_count == 3) begin // 1, 0, 1 sequence detected
                next_state = DETECT_Y;
            end else begin
                next_state = DETECT_SEQ;
            end
        end
        DETECT_Y: begin
            if (y) begin
                next_state = G_HIGH;
            end else if (y_count == 2) begin // y not detected within 2 cycles
                next_state = DETECT_SEQ;
            end else begin
                next_state = DETECT_Y;
            end
        end
        G_HIGH: begin
            next_state = G_HIGH;
        end
    endcase
end

always @ (posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_count <= 0;
    end else begin
        state <= next_state;
        case (state)
            PULSE_F: begin
                f <= 1;
            end
            DETECT_SEQ: begin
                if (x == 1 && x_count == 0) begin
                    x_count <= 1;
                end else if (x == 0 && x_count == 1) begin
                    x_count <= 2;
                end else if (x == 1 && x_count == 2) begin
                    x_count <= 3;
                end else begin
                    x_count <= 0;
                end
            end
            DETECT_Y: begin
                y_count <= y_count + 1;
                if (y) begin
                    g <= 1;
                end
            end
            G_HIGH: begin
                g <= 1;
            end
            default: begin
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

endmodule