module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    // State encoding using typedef enum for readability and synthesis friendliness
    typedef enum logic [0:0] {OFF = 1'b0, ON = 1'b1} state_t;
    state_t state, next_state;

    // Next state combinational logic
    always @(*) begin
        case(state)
            OFF:  next_state = (j) ? ON : OFF;
            ON:   next_state = (k) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Output logic (Moore FSM): output depends only on current state
    always @(*) begin
        case(state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
            default: out = 1'b0;
        endcase
    end

    // State register with synchronous active-high reset, unconditional update
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

endmodule