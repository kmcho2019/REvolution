module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // Define states using enumerated type for clarity
    typedef enum logic {OFF = 1'b0, ON = 1'b1} state_t;
    state_t state, next_state;

    // Combinational block: next state logic
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Sequential block: state register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output: depends only on current state
    assign out = (state == ON);

endmodule