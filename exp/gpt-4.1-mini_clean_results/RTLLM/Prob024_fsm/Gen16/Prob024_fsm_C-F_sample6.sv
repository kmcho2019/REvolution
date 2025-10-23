module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding representing matched prefix of "10011":
    // 0: no match
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001'
    reg [2:0] state, next_state;

    // Combinational next-state logic using case statement for clarity
    always @(*) begin
        case (state)
            3'd0: begin
                if (IN)
                    next_state = 3'd1;  // matched first '1'
                else
                    next_state = 3'd0;  // stay idle
            end

            3'd1: begin
                if (~IN)
                    next_state = 3'd2;  // matched '10'
                else
                    next_state = 3'd1;  // repeated '1', stay in this state
            end

            3'd2: begin
                if (~IN)
                    next_state = 3'd3;  // matched '100'
                else
                    next_state = 3'd1;  // input '1' can start new sequence
            end

            3'd3: begin
                if (IN)
                    next_state = 3'd4;  // matched '1001'
                else
                    next_state = 3'd0;  // mismatch, reset
            end

            3'd4: begin
                if (IN)
                    next_state = 3'd1;  // full sequence matched, restart from '1'
                else
                    next_state = 3'd2;  // partial overlap: '10' matched
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

    // Mealy output: MATCH asserted combinationally when the sequence is complete
    assign MATCH = (state == 3'd4) && (IN == 1'b1);

endmodule