module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Define FSM states as binary-encoded:
    // 0: no bits matched
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001'
    // (5 possible states: 3 bits sufficient, but 3 bits used for clarity)

    reg [2:0] state, next_state;

    // Sequential state update
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // Next state logic using case statement
    always @(*) begin
        case (state)
            3'd0: // no match yet
                if (IN == 1'b1)
                    next_state = 3'd1;  // matched first '1'
                else
                    next_state = 3'd0;  // stay in no match

            3'd1: // matched '1'
                if (IN == 1'b0)
                    next_state = 3'd2;  // matched '10'
                else
                    next_state = 3'd1;  // still '1', could be overlapping start

            3'd2: // matched '10'
                if (IN == 1'b0)
                    next_state = 3'd3;  // matched '100'
                else
                    next_state = 3'd1;  // restart from '1'

            3'd3: // matched '100'
                if (IN == 1'b1)
                    next_state = 3'd4;  // matched '1001'
                else
                    next_state = 3'd0;  // reset to no match

            3'd4: // matched '1001'
                if (IN == 1'b1)
                    next_state = 3'd1;  // matched full sequence, also restart overlapping from '1'
                else
                    next_state = 3'd2;  // '0' after '1001' moves to '10' prefix

            default:
                next_state = 3'd0;
        endcase
    end

    // MATCH output is high when in state 4 and IN is 1, completing the sequence "10011"
    assign MATCH = (state == 3'd4) && (IN == 1'b1);

endmodule