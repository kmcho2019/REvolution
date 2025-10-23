module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    typedef enum logic [1:0] {
        IDLE,
        RISE_DETECTED,
        FALL_DETECTED
    } state_t;

    state_t current_state, next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (a) next_state = RISE_DETECTED;
                else if (~a) next_state = FALL_DETECTED;
                else next_state = IDLE;
            end
            RISE_DETECTED: begin
                if (~a) next_state = FALL_DETECTED;
                else next_state = IDLE;
            end
            FALL_DETECTED: begin
                if (a) next_state = RISE_DETECTED;
                else next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic (Moore style)
    always @(*) begin
        rise = (current_state == RISE_DETECTED);
        down = (current_state == FALL_DETECTED);
    end

endmodule