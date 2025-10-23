module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

typedef enum logic [2:0] {
    STATE_A,  // Initial state while reset is asserted
    STATE_B,  // State to set f to 1 for one clock cycle after reset
    STATE_C,  // State to monitor x for sequence 1, 0, 1
    STATE_D,  // State to set g to 1 after detecting sequence in x
    STATE_E,  // State to monitor y while g is 1
    STATE_F,  // State where g remains 1 permanently
    STATE_G   // State where g is set to 0 permanently
} state_t;

state_t current_state, next_state;
logic [1:0] x_sequence;  // To track the sequence of x (1, 0, 1)
logic [1:0] y_timer;     // Timer to check if y becomes 1 within 2 cycles

always_ff @(posedge clk) begin
    if (!resetn) begin
        current_state <= STATE_A;
        f <= 0;
        g <= 0;
        x_sequence <= 0;
        y_timer <= 0;
    end else begin
        current_state <= next_state;
        case (current_state)
            STATE_A: begin
                f <= 0;
                g <= 0;
            end
            STATE_B: begin
                f <= 1;
                g <= 0;
            end
            STATE_C: begin
                f <= 0;
                g <= 0;
            end
            STATE_D: begin
                f <= 0;
                g <= 1;
            end
            STATE_E: begin
                f <= 0;
                if (y) begin
                    g <= 1;
                end else begin
                    g <= (y_timer == 2)? 0 : 1;
                end
            end
            STATE_F: begin
                f <= 0;
                g <= 1;
            end
            STATE_G: begin
                f <= 0;
                g <= 0;
            end
            default: begin
                f <= 0;
                g <= 0;
            end
        endcase
        x_sequence <= (current_state == STATE_C)? {x_sequence[0], x} : 0;
        y_timer <= (current_state == STATE_E)? (y? 0 : y_timer + 1) : 0;
    end
end

always_comb begin
    case (current_state)
        STATE_A: begin
            if (!resetn) begin
                next_state = STATE_A;
            end else begin
                next_state = STATE_B;
            end
        end
        STATE_B: begin
            next_state = STATE_C;
        end
        STATE_C: begin
            if (x_sequence == 2'b101) begin
                next_state = STATE_D;
            end else begin
                next_state = STATE_C;
            end
        end
        STATE_D: begin
            next_state = STATE_E;
        end
        STATE_E: begin
            if (y) begin
                next_state = STATE_F;
            end else if (y_timer == 2) begin
                next_state = STATE_G;
            end else begin
                next_state = STATE_E;
            end
        end
        STATE_F: begin
            next_state = STATE_F;
        end
        STATE_G: begin
            next_state = STATE_G;
        end
        default: begin
            next_state = STATE_A;
        end
    endcase
end

endmodule