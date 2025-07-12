module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // Sequence to detect: 1 0 0 1 1
    // States represent number of matched bits of the sequence prefix:
    // 0: no match
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001'
    // 5: matched '10011' (full match) - transient output state

    reg [2:0] state, next_state;

    always @(posedge CLK) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    always @(*) begin
        // Default values
        next_state = 3'd0;
        MATCH = 1'b0;

        case(state)
            3'd0: begin
                if (IN == 1'b1)
                    next_state = 3'd1;
                else
                    next_state = 3'd0;
            end
            3'd1: begin
                if (IN == 1'b0)
                    next_state = 3'd2;
                else
                    next_state = 3'd1; // Still matches '1' start of pattern
            end
            3'd2: begin
                if (IN == 1'b0)
                    next_state = 3'd3;
                else
                    next_state = 3'd1; // Overlap: new '1'
            end
            3'd3: begin
                if (IN == 1'b1)
                    next_state = 3'd4;
                else
                    next_state = 3'd0; // Pattern broken
            end
            3'd4: begin
                if (IN == 1'b1) begin
                    next_state = 3'd1; // Overlap start
                    MATCH = 1'b1;      // Full match completed here
                end else begin
                    next_state = 3'd2; // Potential overlap with '10'
                    MATCH = 1'b0;
                end
            end
            default: begin
                next_state = 3'd0;
                MATCH = 1'b0;
            end
        endcase
    end

endmodule