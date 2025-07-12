module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

    // State definitions
    enum logic [3:0] {
        IDLE = 4'b0000, // No consecutive 1s
        ONE = 4'b0001,  // One consecutive 1
        TWO = 4'b0010,  // Two consecutive 1s
        THREE = 4'b0011, // Three consecutive 1s
        FOUR = 4'b0100,  // Four consecutive 1s
        FIVE = 4'b0101,  // Five consecutive 1s
        SIX = 4'b0110,   // Six consecutive 1s
        ERROR = 4'b0111  // 7 or more consecutive 1s
    } state, next_state;

    // Output logic
    always_comb begin
        case(state)
            IDLE: begin
                disc = 0;
                flag = 0;
                err = 0;
            end
            ONE: begin
                disc = 0;
                flag = 0;
                err = 0;
            end
            TWO: begin
                disc = 0;
                flag = 0;
                err = 0;
            end
            THREE: begin
                disc = 0;
                flag = 0;
                err = 0;
            end
            FOUR: begin
                disc = 0;
                flag = 0;
                err = 0;
            end
            FIVE: begin
                disc = 1; // signal that the next 0 should be discarded
                flag = 0;
                err = 0;
            end
            SIX: begin
                disc = 0;
                flag = 1; // flag indicates start or end of frame
                err = 0;
            end
            ERROR: begin
                disc = 0;
                flag = 0;
                err = 1;
            end
            default: begin
                disc = 0;
                flag = 0;
                err = 0;
            end
        endcase
    end

    // Next state logic
    always_comb begin
        case(state)
            IDLE: begin
                if (in) begin
                    next_state = ONE;
                end else begin
                    next_state = IDLE;
                end
            end
            ONE: begin
                if (in) begin
                    next_state = TWO;
                end else begin
                    next_state = IDLE;
                end
            end
            TWO: begin
                if (in) begin
                    next_state = THREE;
                end else begin
                    next_state = IDLE;
                end
            end
            THREE: begin
                if (in) begin
                    next_state = FOUR;
                end else begin
                    next_state = IDLE;
                end
            end
            FOUR: begin
                if (in) begin
                    next_state = FIVE;
                end else begin
                    next_state = IDLE;
                end
            end
            FIVE: begin
                if (in) begin
                    next_state = SIX;
                end else begin
                    next_state = IDLE; // ignore the zero after five 1s
                end
            end
            SIX: begin
                if (in) begin
                    next_state = ERROR;
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
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // State register
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

endmodule