module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // Binary-encoded states for sequence "10011"
    // State encoding (3 bits):
    // 0: no match yet (start)
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001'
    // 5: matched '10011' (sequence complete) - transient

    reg [2:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        MATCH = 1'b0;  // default no match
        case (state)
            3'd0: next_state = (IN) ? 3'd1 : 3'd0;           // Wait for first '1'
            3'd1: next_state = (IN) ? 3'd1 : 3'd2;           // got '1', check next '0'
            3'd2: next_state = (IN) ? 3'd1 : 3'd3;           // got '10', next bit '0'
            3'd3: next_state = (IN) ? 3'd4 : 3'd0;           // got '100', expect '1'
            3'd4: begin
                if (IN) begin
                    next_state = 3'd1;    // full match completed, restart for overlap
                    MATCH = 1'b1;         // Mealy output asserted here
                end else
                    next_state = 3'd2;    // if '0', fallback to state for '10'
            end
            default: next_state = 3'd0;
        endcase
    end

    // Sequential state update
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= 3'd0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is combinationally assigned above and also latched here to align with output timing
            // To ensure MATCH is asserted in the clock cycle output is expected,
            // we register it here as well.
            if (state == 3'd4 && IN == 1'b1)
                MATCH <= 1'b1;
            else
                MATCH <= 1'b0;
        end
    end

endmodule