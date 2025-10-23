module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

typedef enum logic [2:0] {
    IDLE,
    ONE,
    TWO_ONES,
    THREE_ONES,
    FOUR_ONES,
    FIVE_ONES,
    DISCARD,
    FLAG
} state_t;

state_t state, next_state;

always @(*) begin
    case (state)
        IDLE: begin
            if (in)
                next_state = ONE;
            else
                next_state = IDLE;
        end
        ONE: begin
            if (in)
                next_state = TWO_ONES;
            else
                next_state = IDLE;
        end
        TWO_ONES: begin
            if (in)
                next_state = THREE_ONES;
            else
                next_state = IDLE;
        end
        THREE_ONES: begin
            if (in)
                next_state = FOUR_ONES;
            else
                next_state = IDLE;
        end
        FOUR_ONES: begin
            if (in)
                next_state = FIVE_ONES;
            else
                next_state = IDLE;
        end
        FIVE_ONES: begin
            if (in)
                next_state = DISCARD;
            else
                next_state = IDLE;
        end
        DISCARD: begin
            if (in)
                next_state = FLAG;
            else
                next_state = IDLE;
        end
        FLAG: begin
            if (in)
                next_state = FLAG; // Stay in FLAG state to signal an error after one cycle
            else
                next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        state <= next_state;
        case (state)
            DISCARD: disc <= 1;
            default: disc <= 0;
        endcase
        case (state)
            FLAG: flag <= 1;
            default: flag <= 0;
        endcase
        case (state)
            FLAG: err <= 1;
            default: err <= 0;
        endcase
    end
end

endmodule