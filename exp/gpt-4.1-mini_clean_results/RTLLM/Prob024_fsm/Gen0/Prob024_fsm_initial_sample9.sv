module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    // State encoding
    typedef enum reg [2:0] {
        S0 = 3'd0, // no match yet
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4, // matched '1001'
        S5 = 3'd5  // matched '10011' (final)
    } state_t;

    state_t state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            S0: 
                if (IN == 1'b1) next_state = S1;
                else next_state = S0;

            S1:
                if (IN == 1'b0) next_state = S2;
                else next_state = S1;  // input 1 at S1 means restart sequence from first '1'

            S2:
                if (IN == 1'b0) next_state = S3;
                else if (IN == 1'b1) next_state = S1; // restart partial matching at first '1'

            S3:
                if (IN == 1'b1) next_state = S4;
                else next_state = S0;

            S4:
                if (IN == 1'b1) next_state = S5;
                else if (IN == 1'b0) next_state = S2; // support looping with partial overlap '00' after '1001'

            S5:
                // After full match, check IN for overlapping detection
                // The last bits were '10011', the next state depends on input to support continuous detection
                if (IN == 1'b0) next_state = S2;
                else next_state = S1;
                
            default: next_state = S0;
        endcase
    end

    // State and output register update (sequential)
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is asserted when entering S5 at the current input
            // Since it's a Mealy FSM, MATCH depends on state and input, so can use next_state
            MATCH <= (next_state == S5) ? 1'b1 : 1'b0;
        end
    end

endmodule