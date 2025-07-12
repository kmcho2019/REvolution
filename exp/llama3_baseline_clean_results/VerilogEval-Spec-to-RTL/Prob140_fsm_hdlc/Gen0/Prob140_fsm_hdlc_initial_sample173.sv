module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// States of the FSM
enum logic [2:0] {IDLE, ONE, ONES1, ONES2, ONES3, ONES4, ONES5, FLAG_FOUND, FLAG_START} state, nextState;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        state <= nextState;
        case (state)
            FLAG_FOUND: begin
                disc <= 1;
                flag <= 0;
                err <= 0;
            end
            FLAG_START: begin
                disc <= 0;
                flag <= 1;
                err <= 0;
            end
            default: begin
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
        endcase

        if (state == ONES5 && in == 1) begin
            err <= 1;
        end
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
                nextState = ONES1;
            end else begin
                nextState = IDLE;
            end
        end
        ONES1: begin
            if (in) begin
                nextState = ONES2;
            end else begin
                nextState = IDLE;
            end
        end
        ONES2: begin
            if (in) begin
                nextState = ONES3;
            end else begin
                nextState = IDLE;
            end
        end
        ONES3: begin
            if (in) begin
                nextState = ONES4;
            end else begin
                nextState = IDLE;
            end
        end
        ONES4: begin
            if (in) begin
                nextState = ONES5;
            end else begin
                nextState = IDLE;
            end
        end
        ONES5: begin
            if (in) begin
                // 7 or more consecutive '1's is an error
                nextState = ONES5;
            end else begin
                nextState = FLAG_FOUND;
            end
        end
        FLAG_FOUND: begin
            if (in) begin
                // This should not happen, but to be safe
                nextState = IDLE;
            end else begin
                nextState = FLAG_START;
            end
        end
        FLAG_START: begin
            // After flag, return to IDLE
            nextState = IDLE;
        end
        default: begin
            nextState = IDLE;
        end
    endcase
end

endmodule