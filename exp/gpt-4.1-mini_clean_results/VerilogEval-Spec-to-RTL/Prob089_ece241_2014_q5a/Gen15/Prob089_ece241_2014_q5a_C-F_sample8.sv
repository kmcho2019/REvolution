module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // Enumerated FSM states for clarity
    typedef enum logic {COPY = 1'b0, INVERT = 1'b1} state_t;

    state_t state, next_state;
    logic x_reg;

    // Sequential logic: asynchronous reset, sample input and update state on clock edge
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            x_reg <= 1'b0;
        end else begin
            state <= next_state;
            x_reg <= x;
        end
    end

    // Combinational next state logic depends on current state and sampled input
    always_comb begin
        case (state)
            COPY: next_state = (x_reg == 1'b1) ? INVERT : COPY;
            INVERT: next_state = INVERT;
            default: next_state = COPY;
        endcase
    end

    // Moore output: z = x_reg XOR (state == INVERT)
    assign z = x_reg ^ state;

endmodule