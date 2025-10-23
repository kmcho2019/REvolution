module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    typedef enum logic {COPY=1'b0, INVERT=1'b1} state_t;
    state_t state, next_state;

    // State register with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= COPY;
        else
            state <= next_state;
    end

    // Next state logic
    always_comb begin
        case(state)
            COPY: next_state = x ? INVERT : COPY;
            INVERT: next_state = INVERT;
            default: next_state = COPY;
        endcase
    end

    // Moore output: output depends only on current state and input x
    assign z = x ^ state;

endmodule