module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // Define states
    typedef enum logic [2:0] {
        S0,    // No match
        S1,    // Matched '1'
        S2,    // Matched '11'
        S3,    // Matched '110'
        S4     // Matched '1101' (complete)
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always_comb begin
        case (current_state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4;  // Stay in matched state
            default: next_state = S0;
        endcase
    end

    // State register
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    // Output is high when in final state
    assign start_shifting = (current_state == S4);

endmodule