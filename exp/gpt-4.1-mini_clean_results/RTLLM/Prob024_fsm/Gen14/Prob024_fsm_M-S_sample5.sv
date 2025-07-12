module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // States encoding (binary):
    // 0: S0 - no match
    // 1: S1 - matched '1'
    // 2: S2 - matched '10'
    // 3: S3 - matched '100'
    // 4: S4 - matched '1001'
    // 5: S5 - matched '10011' (final state reached on input)

    reg [2:0] state, next_state;

    // Next state logic combinational
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

    // State register and MATCH output update on clock edge
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= 3'd0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is 1 only when current input completes pattern: on transition to state 5, input=1
            // Since next_state computed based on current input, MATCH = 1 when next_state == 5
            MATCH <= (next_state == 3'd5);
        end
    end

endmodule