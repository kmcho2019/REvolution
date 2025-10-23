module TopModule (
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

enum logic [2:0] {IDLE, ONE, TWO_TO_FIVE, SIX, SEVEN_PLUS, FLAG} state, nextState;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        state <= nextState;
        case (state)
            SIX: disc <= 1;
            SEVEN_PLUS: err <= 1;
            FLAG: flag <= 1;
            default: begin
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
        endcase
    end
end

always_comb begin
    case (state)
        IDLE: begin
            if (in) begin
                nextState = ONE;
            end else begin
                nextState = IDLE;
            end
        end
        ONE: begin
            if (in) begin
                nextState = TWO_TO_FIVE;
            end else begin
                nextState = IDLE;
            end
        end
        TWO_TO_FIVE: begin
            if (in) begin
                nextState = (state == TWO_TO_FIVE && in) ? SIX : TWO_TO_FIVE;
            end else begin
                nextState = IDLE;
            end
        end
        SIX: begin
            if (in) begin
                nextState = SEVEN_PLUS;
            end else begin
                nextState = IDLE;
            end
        end
        SEVEN_PLUS: begin
            if (in) begin
                nextState = SEVEN_PLUS;
            end else begin
                nextState = IDLE;
            end
        end
        FLAG: begin
            nextState = IDLE;
        end
        default: nextState = IDLE;
    endcase
    if (state == SIX && in && ~in) nextState = FLAG;
end

endmodule