module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // States encoding
    typedef enum logic [2:0] {
        S0 = 3'd0, // initial state, no matched bits
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4  // matched '1001'
    } state_t;

    state_t state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            S0: next_state = (IN == 1'b1) ? S1 : S0;
            S1: next_state = (IN == 1'b0) ? S2 : S1; // if input=1 remain in S1, else go to S2
            S2: next_state = (IN == 1'b0) ? S3 : S1; // if input=0 go to S3 else if 1 go back to S1
            S3: next_state = (IN == 1'b1) ? S4 : S0; // if input=1 go to S4 else reset to S0
            S4: next_state = (IN == 1'b1) ? S1 : S2; // after matching '1001', next input 1 -> S1 else 0 -> S2 (to allow overlap)
            default: next_state = S0;
        endcase
    end

    // State register and MATCH output (Mealy output)
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH = 1 only when in S4 and input = 1 (detected '10011')
            if (state == S4 && IN == 1'b1)
                MATCH <= 1'b1;
            else
                MATCH <= 1'b0;
        end
    end

endmodule