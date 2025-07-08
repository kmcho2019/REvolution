module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // Define FSM states
    typedef enum logic [2:0] {
        S0, // no match yet
        S1, // matched '1'
        S11, // matched '11'
        S110, // matched '110'
        S1101_FOUND // sequence found
    } state_t;

    state_t state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case(state)
            S0:    next_state = (data) ? S1 : S0;
            S1:    next_state = (data) ? S11 : S0;
            S11:   next_state = (data) ? S11 : S110;
            S110:  next_state = (data) ? S1101_FOUND : S0;
            S1101_FOUND: next_state = S1101_FOUND;
            default: next_state = S0;
        endcase
    end

    // Sequential state update and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (state == S1101_FOUND || next_state == S1101_FOUND)
                start_shifting <= 1'b1;
        end
    end

endmodule