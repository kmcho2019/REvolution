module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output z
);

    // State encoding for sequence detection "101"
    typedef enum logic [1:0] {
        S0 = 2'b00,  // initial state, no bits matched
        S1 = 2'b01,  // matched '1'
        S2 = 2'b10   // matched "10"
    } state_t;

    state_t state, next_state;

    // Next-state logic with case statement for clarity
    always @(*) begin
        case(state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output logic as combinational assign
    // z asserted when current state is S2 and input x is 1 (detecting "101")
    assign z = (state == S2) && x;

endmodule