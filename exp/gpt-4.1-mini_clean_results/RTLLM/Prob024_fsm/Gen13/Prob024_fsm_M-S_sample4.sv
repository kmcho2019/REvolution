module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // States representing how many bits matched so far (0 to 5)
    // 0: no match yet
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001'
    // 5: matched '10011' (final match)
    reg [2:0] state, next_state;

    // Sequential logic: state update on clock or reset
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // Next state logic based on current state and input
    always @(*) begin
        case (state)
            3'd0: next_state = (IN) ? 3'd1 : 3'd0;
            3'd1: next_state = (IN) ? 3'd1 : 3'd2;
            3'd2: next_state = (IN) ? 3'd1 : 3'd3;
            3'd3: next_state = (IN) ? 3'd4 : 3'd0;
            3'd4: next_state = (IN) ? 3'd5 : 3'd2;
            3'd5: next_state = (IN) ? 3'd1 : 3'd2; // after match, allow overlap
            default: next_state = 3'd0;
        endcase
    end

    // Mealy output: MATCH is 1 when sequence completed at this input
    always @(*) begin
        // MATCH asserted when currently in state 4 and input IN=1 (completing the sequence)
        MATCH = (state == 3'd4) && (IN == 1'b1);
    end

endmodule