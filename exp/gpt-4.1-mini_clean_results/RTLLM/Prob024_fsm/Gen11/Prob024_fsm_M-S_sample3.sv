module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // States represent how many bits matched: 0 to 4
    // Sequence: 1 0 0 1 1
    reg [2:0] state, next_state;

    // Next-state logic according to pattern matching with overlaps
    always @(*) begin
        case(state)
            3'd0: // no match yet
                next_state = (IN == 1'b1) ? 3'd1 : 3'd0;
            3'd1: // matched '1'
                next_state = (IN == 1'b0) ? 3'd2 : 3'd1;
            3'd2: // matched '10'
                next_state = (IN == 1'b0) ? 3'd3 : 3'd1;
            3'd3: // matched '100'
                next_state = (IN == 1'b1) ? 3'd4 : 3'd0;
            3'd4: // matched '1001'
                // If IN=1, full sequence matched
                // After MATCH, transition depending on input for overlaps
                next_state = (IN == 1'b1) ? 3'd1 : 3'd2;
            default:
                next_state = 3'd0;
        endcase
    end

    // State register and MATCH output generation (Mealy)
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= 3'd0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is asserted when in state 4 and IN=1 (sequence completed)
            MATCH <= (state == 3'd4) && (IN == 1'b1);
        end
    end

endmodule