module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        RISE_DETECTED,
        FALL_DETECTED
    } state_t;

    state_t current_state, next_state;
    reg a_prev;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            a_prev <= 1'b0;
        end else begin
            current_state <= next_state;
            a_prev <= a;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (a && !a_prev)
                    next_state = RISE_DETECTED;
                else if (!a && a_prev)
                    next_state = FALL_DETECTED;
            end
            RISE_DETECTED,
            FALL_DETECTED: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        rise = 1'b0;
        down = 1'b0;
        case (current_state)
            RISE_DETECTED: rise = 1'b1;
            FALL_DETECTED: down = 1'b1;
            default: ;
        endcase
    end

endmodule