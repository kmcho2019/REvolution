module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // States: WAIT = 0, DONE = 1
    typedef enum logic {WAIT=1'b0, DONE=1'b1} state_t;
    state_t state, next_state;

    // State register with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= WAIT;
        else
            state <= next_state;
    end

    // Next state logic
    always_comb begin
        case(state)
            WAIT:
                // Stay in WAIT until first '1' detected, then go to DONE
                if (x == 1'b1)
                    next_state = DONE;
                else
                    next_state = WAIT;
            DONE:
                // Remain in DONE
                next_state = DONE;
            default:
                next_state = WAIT;
        endcase
    end

    // Output logic (Moore output) depends only on current state and input x
    // Before first '1', output x directly; after first '1', output inverted x
    assign z = (state == WAIT) ? x : ~x;

endmodule