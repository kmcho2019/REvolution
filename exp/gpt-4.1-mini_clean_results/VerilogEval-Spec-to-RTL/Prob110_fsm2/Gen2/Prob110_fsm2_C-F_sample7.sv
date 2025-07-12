module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // Define FSM states using typedef enum for readability
    typedef enum logic {
        OFF = 1'b0,
        ON  = 1'b1
    } state_t;

    state_t state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
            OFF: next_state = (j == 1'b1) ? ON : OFF;
            ON:  next_state = (k == 1'b1) ? OFF : ON;
            default: next_state = OFF; // safe default state
        endcase
    end

    // Output register logic: output depends only on current state (Moore)
    // Registering output reduces combinational toggling and delays
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;
        else
            out <= (state == ON) ? 1'b1 : 1'b0;
    end

endmodule