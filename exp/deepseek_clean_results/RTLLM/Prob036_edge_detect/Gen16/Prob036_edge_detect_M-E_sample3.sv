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
        FALLING
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
        case (current_state)
            IDLE: begin
                if (a && !a_prev) next_state = RISING;
                else if (!a && a_prev) next_state = FALLING;
                else next_state = IDLE;
            end
            RISING: next_state = IDLE;
            FALLING: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic (Moore style)
    always @(*) begin
        rise = (current_state == RISING);
        down = (current_state == FALLING);
    end

endmodule