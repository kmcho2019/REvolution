module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // Define FSM states
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        BYTE2 = 2'd1,
        BYTE3 = 2'd2,
        DONE_STATE = 2'd3
    } state_t;

    state_t state, next_state;

    // Sequential state register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @* begin
        case(state)
            IDLE: 
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = IDLE;

            BYTE2:
                next_state = BYTE3;

            BYTE3:
                next_state = DONE_STATE;

            DONE_STATE:
                next_state = IDLE;

            default:
                next_state = IDLE;
        endcase
    end

    // done is asserted combinationally when in DONE_STATE
    assign done = (state == DONE_STATE);

endmodule