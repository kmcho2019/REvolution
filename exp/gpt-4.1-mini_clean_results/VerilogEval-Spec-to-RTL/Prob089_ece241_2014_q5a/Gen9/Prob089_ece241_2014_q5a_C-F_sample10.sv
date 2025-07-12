module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // Define state type for clarity
    typedef enum logic {COPY=1'b0, INVERT=1'b1} state_t;

    state_t state, next_state;
    logic x_reg;

    // Input sampling register with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) 
            x_reg <= 1'b0;
        else 
            x_reg <= x;
    end

    // State register with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= COPY;
        else
            state <= next_state;
    end

    // Next state logic: move to INVERT on first ‘1’ in COPY state; remain INVERT after
    always_comb begin
        case(state)
            COPY:   next_state = (x_reg == 1'b1) ? INVERT : COPY;
            INVERT: next_state = INVERT;
            default: next_state = COPY;
        endcase
    end

    // Moore output: z depends only on registered input and FSM state
    assign z = x_reg ^ (state == INVERT);

endmodule