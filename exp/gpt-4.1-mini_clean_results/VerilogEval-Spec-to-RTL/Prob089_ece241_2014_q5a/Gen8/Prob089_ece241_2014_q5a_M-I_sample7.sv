module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // Enumerated state type: COPY=0 (no inversion), INVERT=1 (invert)
    typedef enum logic {COPY = 1'b0, INVERT = 1'b1} state_t;

    state_t state, next_state;

    // State register with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= COPY;
        else
            state <= next_state;
    end

    // Next state logic using raw input x directly
    always_comb begin
        case (state)
            COPY: begin
                if (x == 1'b1)
                    next_state = INVERT;
                else
                    next_state = COPY;
            end
            INVERT: begin
                next_state = INVERT;
            end
            default: next_state = COPY;
        endcase
    end

    // Output combinational logic: Moore FSM output is x XOR state
    assign z = x ^ state;

endmodule