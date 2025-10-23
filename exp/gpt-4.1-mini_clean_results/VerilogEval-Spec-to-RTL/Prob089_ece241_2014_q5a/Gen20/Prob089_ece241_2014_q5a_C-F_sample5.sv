module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // Enumerated states for clarity
    typedef enum logic {COPY = 1'b0, INVERT = 1'b1} state_t;

    state_t state, next_state;

    // Sequential logic: update state and sample input 'x' synchronously, asynchronous reset
    reg x_reg;
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            x_reg <= 1'b0;
        end else begin
            state <= next_state;
            x_reg <= x;
        end
    end

    // Next-state combinational logic
    always_comb begin
        case (state)
            COPY: next_state = x_reg ? INVERT : COPY;
            INVERT: next_state = INVERT;
            default: next_state = COPY;
        endcase
    end

    // Output combinational logic: Moore output depends on registered state and input sample
    assign z = (state == COPY) ? x_reg : ~x_reg;

endmodule