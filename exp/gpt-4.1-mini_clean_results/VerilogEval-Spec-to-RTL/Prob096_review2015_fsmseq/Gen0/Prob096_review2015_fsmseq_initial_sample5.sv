module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    typedef enum logic [1:0] {
        S0   = 2'b00,
        S1   = 2'b01,
        S11  = 2'b10,
        S110 = 2'b11
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S11 : S0;
            S11: next_state = data ? S11 : S110;
            S110: next_state = data ? S1 : S0; // after 1101 found, start_shifting asserted forever; continue tracking for FSM
            default: next_state = S0;
        endcase
    end

    // Sequential logic: state update and start_shifting latch
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (state == S110 && data == 1'b1) // input bit after S110 is data=1?
                start_shifting <= 1'b1;
            else if (state == S110 && data == 1'b0)
                start_shifting <= 1'b1; // because sequence 1101 ends with data=1 in that last bit (state S110 expects data=1 for the final match)
            else if (start_shifting)
                start_shifting <= 1'b1;
        end
    end

endmodule