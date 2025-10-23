module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // Enumerated state type: COPY=0, INVERT=1
    typedef enum logic {COPY = 1'b0, INVERT = 1'b1} state_t;

    state_t state, next_state;

    // Asynchronous reset and state register update
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= COPY;
        else
            state <= next_state;
    end

    // Next state logic
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

    // Output z: Moore FSM output = x XOR inversion_bit, where inversion_bit = (state == INVERT)
    assign z = x ^ (state == INVERT);

endmodule