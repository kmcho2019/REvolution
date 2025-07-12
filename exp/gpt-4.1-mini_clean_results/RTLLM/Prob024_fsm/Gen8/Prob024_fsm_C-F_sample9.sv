module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding:
    // 0: no match yet
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001'

    reg [2:0] state, next_state;

    // Combinational next-state logic
    always @(*) begin
        case (state)
            3'd0: begin
                // no bits matched
                if (IN == 1'b1)
                    next_state = 3'd1; // matched first '1'
                else
                    next_state = 3'd0;
            end
            3'd1: begin
                // matched '1'
                if (IN == 1'b0)
                    next_state = 3'd2; // matched '10'
                else
                    next_state = 3'd1; // still matched '1' (could be start of new pattern)
            end
            3'd2: begin
                // matched '10'
                if (IN == 1'b0)
                    next_state = 3'd3; // matched '100'
                else
                    next_state = 3'd1; // input '1' could be start of new pattern
            end
            3'd3: begin
                // matched '100'
                if (IN == 1'b1)
                    next_state = 3'd4; // matched '1001'
                else
                    next_state = 3'd0; // mismatch, reset
            end
            3'd4: begin
                // matched '1001'
                if (IN == 1'b1)
                    next_state = 3'd1; // full match on this '1'; overlap start with new pattern
                else // IN == 0
                    next_state = 3'd2; // partial overlap for '10'
            end
            default: next_state = 3'd0;
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH asserted when state is 4 and input IN is 1,
    // indicating completion of "10011"
    assign MATCH = (state == 3'd4) && (IN == 1'b1);

endmodule