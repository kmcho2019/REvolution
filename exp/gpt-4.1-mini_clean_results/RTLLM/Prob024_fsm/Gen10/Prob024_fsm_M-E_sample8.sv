module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding
    typedef enum logic [2:0] {
        S0 = 3'd0, // no bits matched
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4, // matched '1001'
        S5 = 3'd5  // matched '10011' (final match)
    } state_t;

    state_t state, next_state;

    // Next-state logic function: determines next state based on current state and input
    function state_t next_state_func(state_t curr, logic bit_in);
        begin
            case (curr)
                S0: next_state_func = (bit_in == 1'b1) ? S1 : S0;
                S1: next_state_func = (bit_in == 1'b0) ? S2 : S1;
                S2: next_state_func = (bit_in == 1'b0) ? S3 : S1;
                S3: next_state_func = (bit_in == 1'b1) ? S4 : S0;
                S4: begin
                    if (bit_in == 1'b1) 
                        next_state_func = S5; // full match
                    else 
                        next_state_func = S2; // overlapping fallback to S2
                end
                S5: begin
                    // After full match, go to appropriate state to enable overlapping
                    // The last input was '1' (IN=1), so we check next input accordingly
                    // On next cycle, IN determines next_state:
                    // If next IN=1, go S1 else S0
                    // But since this function doesn't know next input, fallback:
                    // To handle overlapping, we treat next input as current 'bit_in'
                    // So:
                    if (bit_in == 1'b1)
                        next_state_func = S1;
                    else
                        next_state_func = S0;
                end
                default: next_state_func = S0;
            endcase
        end
    endfunction

    // State register update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state_func(state, IN);
    end

    // Mealy output: MATCH=1 when in S4 and input bit is 1 (final input of sequence)
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule