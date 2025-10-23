module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding (binary):
    // 0: no match yet
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001'
    // 5: matched full '10011' (not used as stable state, output detected combinationally)

    reg [2:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            3'd0: begin
                // no match yet
                if (IN == 1'b1)
                    next_state = 3'd1; // first '1' matched
                else
                    next_state = 3'd0;
            end
            3'd1: begin
                // matched '1'
                if (IN == 1'b0)
                    next_state = 3'd2; // matched '10'
                else
                    next_state = 3'd1; // still '1', stay here since input '1' could be start again
            end
            3'd2: begin
                // matched '10'
                if (IN == 1'b0)
                    next_state = 3'd3; // matched '100'
                else
                    next_state = 3'd1; // got '1', restart at matching '1'
            end
            3'd3: begin
                // matched '100'
                if (IN == 1'b1)
                    next_state = 3'd4; // matched '1001'
                else
                    next_state = 3'd0; // input '0' breaks pattern, reset
            end
            3'd4: begin
                // matched '1001'
                if (IN == 1'b1)
                    next_state = 3'd1; // complete sequence; overlapping: '1' could start new pattern
                else if (IN == 1'b0)
                    next_state = 3'd2; // input '0' could be part of new pattern after match
                else
                    next_state = 3'd0;
            end
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

    // Mealy output: MATCH = 1 when state is 4 and input IN = 1 (final bit of sequence)
    assign MATCH = (state == 3'd4) && (IN == 1'b1);

endmodule