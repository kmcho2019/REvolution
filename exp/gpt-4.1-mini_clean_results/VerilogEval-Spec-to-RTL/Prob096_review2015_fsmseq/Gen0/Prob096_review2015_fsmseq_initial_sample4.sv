module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding for sequence detection of 1101
    typedef enum logic [2:0] {
        S0 = 3'd0, // initial state, no matches
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '11'
        S3 = 3'd3, // matched '110'
        S4 = 3'd4  // matched '1101' (sequence found)
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            S0: next_state = (data == 1'b1) ? S1 : S0;
            S1: next_state = (data == 1'b1) ? S2 : S0;
            S2: next_state = (data == 1'b0) ? S3 : S2; // Stay in S2 if next bit 1
            S3: next_state = (data == 1'b1) ? S4 : S0;
            S4: next_state = S4; // Stay in S4 after detection
            default: next_state = S0;
        endcase
    end

    // State and output sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == S4)
                start_shifting <= 1'b1;
        end
    end

endmodule