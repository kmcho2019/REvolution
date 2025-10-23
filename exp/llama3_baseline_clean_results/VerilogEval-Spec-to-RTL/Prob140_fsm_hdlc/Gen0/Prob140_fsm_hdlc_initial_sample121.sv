module TopModule (
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

// States for the FSM
enum logic [2:0] {
    IDLE,  // Initial state
    ONE,   // One 1
    TWO_1s,  // Two 1s
    THREE_1s,  // Three 1s
    FOUR_1s,  // Four 1s
    FIVE_1s,  // Five 1s
    DISCARD,  // Discard state
    FLAG,  // Flag state
    ERROR  // Error state
} state, next_state;

// Current state register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            DISCARD: disc <= 1'b1;
            default: disc <= 1'b0;
        endcase
        case (state)
            FLAG: flag <= 1'b1;
            default: flag <= 1'b0;
        endcase
        case (state)
            ERROR: err <= 1'b1;
            default: err <= 1'b0;
        endcase
    end
end

// Next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (in) begin
                next_state = ONE;
            end else begin
                next_state = IDLE;
            end
        end
        ONE: begin
            if (in) begin
                next_state = TWO_1s;
            end else begin
                next_state = IDLE;
            end
        end
        TWO_1s: begin
            if (in) begin
                next_state = THREE_1s;
            end else begin
                next_state = IDLE;
            end
        end
        THREE_1s: begin
            if (in) begin
                next_state = FOUR_1s;
            end else begin
                next_state = IDLE;
            end
        end
        FOUR_1s: begin
            if (in) begin
                next_state = FIVE_1s;
            end else begin
                next_state = IDLE;
            end
        end
        FIVE_1s: begin
            if (in) begin
                next_state = ERROR;
            end else begin
                next_state = DISCARD;
            end
        end
        DISCARD: begin
            if (in) begin
                next_state = ONE;
            end else begin
                next_state = IDLE;
            end
        end
        FLAG: begin
            if (in) begin
                next_state = ONE;
            end else begin
                next_state = IDLE;
            end
        end
        ERROR: begin
            if (in) begin
                next_state = ERROR;
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule