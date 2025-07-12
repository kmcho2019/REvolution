module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding for prefix matches of "10011"
    // 0: no match yet
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001'

    reg [2:0] state, next_state;

    // Combinational next-state logic based on current state and input IN
    always @(*) begin
        case (state)
            3'd0: begin
                // No bits matched yet
                if (IN == 1'b1)
                    next_state = 3'd1; // matched first '1'
                else
                    next_state = 3'd0; // remain in idle
            end
            3'd1: begin
                // Matched '1'
                if (IN == 1'b0)
                    next_state = 3'd2; // matched '10'
                else
                    next_state = 3'd1; // '1' again, stay in matched '1' state (start of sequence)
            end
            3'd2: begin
                // Matched '10'
                if (IN == 1'b0)
                    next_state = 3'd3; // matched '100'
                else
                    next_state = 3'd1; // input '1' might start new sequence
            end
            3'd3: begin
                // Matched '100'
                if (IN == 1'b1)
                    next_state = 3'd4; // matched '1001'
                else
                    next_state = 3'd0; // mismatch, reset
            end
            3'd4: begin
                // Matched '1001'
                if (IN == 1'b1)
                    next_state = 3'd1; // full match on this '1', also start new sequence
                else // IN == 0
                    next_state = 3'd2; // partial overlap with next possible '10'
            end
            default: next_state = 3'd0;
        endcase
    end

    // Synchronous state update with reset
    always @(posedge CLK) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH asserted when in state 4 and input IN=1 (last bit of "10011")
    assign MATCH = (state == 3'd4) && (IN == 1'b1);

endmodule