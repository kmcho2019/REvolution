module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE,
        RISING,
        FALLING,
        STABLE
    } state_t;

    state_t current_state, next_state;

    // State transition logic
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
                if (a) next_state = RISING;
                else next_state = FALLING;
            end
            RISING: next_state = STABLE;
            FALLING: next_state = STABLE;
            STABLE: begin
                if (a && (current_state == FALLING || current_state == STABLE))
                    next_state = RISING;
                else if (!a && (current_state == RISING || current_state == STABLE))
                    next_state = FALLING;
                else
                    next_state = STABLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        rise = (current_state == RISING);
        down = (current_state == FALLING);
    end

endmodule