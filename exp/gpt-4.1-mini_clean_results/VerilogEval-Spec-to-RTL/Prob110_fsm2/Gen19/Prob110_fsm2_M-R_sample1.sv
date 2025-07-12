module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // State encoding using an enumerated type for clarity
    typedef enum logic {OFF, ON} state_t;
    state_t state, next_state;

    // Next state logic as continuous assignment
    assign next_state = (state == OFF) ? (j ? ON : OFF) :
                        (state == ON)  ? (k ? OFF : ON)  : OFF;

    // State register with asynchronous reset, no clock enable
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic (Moore): output depends solely on current state
    assign out = (state == ON);

endmodule