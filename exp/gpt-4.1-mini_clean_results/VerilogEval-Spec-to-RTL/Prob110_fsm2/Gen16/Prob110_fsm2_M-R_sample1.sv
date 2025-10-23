module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // State encoding using enumerated type
    typedef enum logic {
        OFF = 1'b0,
        ON  = 1'b1
    } state_t;

    state_t state, next_state;

    // Next state combinational logic as continuous assignment
    assign next_state = (state == OFF) ? (j ? ON : OFF) :
                        (state == ON)  ? (k ? OFF : ON) :
                        OFF;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic derived from state (Moore output) as continuous assignment
    assign out = (state == ON);

endmodule