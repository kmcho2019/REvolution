module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    typedef enum logic {WAIT = 1'b0, ADD_ONE = 1'b1} state_t;
    state_t state, next_state;

    // Next state logic combinational
    always_comb begin
        case(state)
            WAIT:    next_state = (x == 1'b1) ? ADD_ONE : WAIT;
            ADD_ONE: next_state = ADD_ONE;
            default: next_state = WAIT;
        endcase
    end

    // Sequential state update with async reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= WAIT;
        else
            state <= next_state;
    end

    // Mealy output depends on current state and input x
    always_comb begin
        case(state)
            WAIT:    z = x;       // copy bits until first '1'
            ADD_ONE: z = ~x;      // invert bits after first '1'
            default: z = x;
        endcase
    end

endmodule