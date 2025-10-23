module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding (binary)
    // States represent how many bits matched so far:
    // 0 = no bits matched
    // 1 = matched '1'
    // 2 = matched '10'
    // 3 = matched '100'
    // 4 = matched '1001'
    // 5 = matched '10011' (full pattern matched)

    reg [2:0] state, next_state;

    // Function to get next state for overlap:
    // We use the prefix function of "10011" to decide next state on input.
    // The pattern: 1 0 0 1 1
    // For each input, we try to find the longest prefix matched.
    // Precompute prefix transitions:
    // State transitions are based on pattern and input:
    // From state=0:
    //  IN=1 -> state=1
    //  IN=0 -> state=0
    // From state=1 ('1'):
    //  IN=0 -> 2 ('10')
    //  IN=1 -> 1 ('1')
    // From state=2 ('10'):
    //  IN=0 -> 3 ('100')
    //  IN=1 -> 1 ('1')
    // From state=3 ('100'):
    //  IN=1 -> 4 ('1001')
    //  IN=0 -> 0
    // From state=4 ('1001'):
    //  IN=1 -> 5 ('10011') (full match)
    //  IN=0 -> 2 ('10') (overlap: last two bits '10')
    // From state=5 (matched full):
    //  IN=1 -> 1 ('1')
    //  IN=0 -> 2 ('10')

    always @(*) begin
        case(state)
            3'd0: next_state = (IN) ? 3'd1 : 3'd0;
            3'd1: next_state = (IN) ? 3'd1 : 3'd2;
            3'd2: next_state = (IN) ? 3'd1 : 3'd3;
            3'd3: next_state = (IN) ? 3'd4 : 3'd0;
            3'd4: next_state = (IN) ? 3'd5 : 3'd2;
            3'd5: next_state = (IN) ? 3'd1 : 3'd2;
            default: next_state = 3'd0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH is 1 when we just matched the full pattern on this input,
    // which corresponds to being in state 4 and input=1 causing transition to 5.
    // So MATCH = (state==4) && (IN==1)
    assign MATCH = (state == 3'd4) && (IN == 1'b1);

endmodule