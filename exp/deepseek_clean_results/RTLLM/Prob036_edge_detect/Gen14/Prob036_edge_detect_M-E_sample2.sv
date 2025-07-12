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
        next_state = current_state;
        rise = 1'b0;
        down = 1'b0;

        case (current_state)
            IDLE: begin
                if (a && !a_prev) begin
                    next_state = RISING;
                end else if (!a && a_prev) begin
                    next_state = FALLING;
                end
            end
            RISING: begin
                rise = 1'b1;
                next_state = IDLE;
            end
            FALLING: begin
                down = 1'b1;
                next_state = IDLE;
            end
        endcase
    end

endmodule