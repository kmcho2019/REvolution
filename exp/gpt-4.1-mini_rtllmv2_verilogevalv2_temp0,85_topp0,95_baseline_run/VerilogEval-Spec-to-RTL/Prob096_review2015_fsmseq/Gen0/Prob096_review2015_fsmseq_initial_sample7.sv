module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding for sequence detection
    // States represent how many bits of "1101" matched so far
    typedef enum reg [2:0] {
        IDLE = 3'd0,       // no match
        S1 = 3'd1,         // matched '1'
        S11 = 3'd2,        // matched '11'
        S110 = 3'd3,       // matched '110'
        FOUND = 3'd4       // matched '1101'
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (data == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                if (data == 1'b1)
                    next_state = S11;
                else
                    next_state = IDLE;
            end

            S11: begin
                if (data == 1'b0)
                    next_state = S110;
                else
                    next_state = S11; // '111' still matches '11' prefix
            end

            S110: begin
                if (data == 1'b1)
                    next_state = FOUND;
                else
                    next_state = IDLE;
            end

            FOUND: begin
                // Stay in FOUND once sequence found
                next_state = FOUND;
            end

            default: next_state = IDLE;
        endcase
    end

    // State and output registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (state == FOUND || start_shifting == 1'b1)
                start_shifting <= 1'b1;
        end
    end

endmodule