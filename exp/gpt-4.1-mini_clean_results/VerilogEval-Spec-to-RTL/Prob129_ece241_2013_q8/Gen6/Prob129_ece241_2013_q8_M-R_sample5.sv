module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    typedef enum logic [1:0] {
        S0 = 2'b00, // no bits matched
        S1 = 2'b01, // matched '1'
        S2 = 2'b10  // matched '10'
    } state_t;

    state_t state, next_state;

    // State register with asynchronous negative-edge reset
    always_ff @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic separate from output logic
    always_comb begin
        case(state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic (Mealy output depends on current state and input)
    always_comb begin
        z = 1'b0;
        if (state == S2 && x)
            z = 1'b1;
    end

endmodule