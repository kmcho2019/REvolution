module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // States encoding:
    // 0 - no match
    // 1 - matched '1'
    // 2 - matched '10'
    // 3 - matched '100'
    // 4 - matched '1001'
    // 5 - matched '10011' (accepting state)

    reg [2:0] state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            3'd0: next_state = (IN == 1'b1) ? 3'd1 : 3'd0;
            3'd1: next_state = (IN == 1'b0) ? 3'd2 : 3'd1;
            3'd2: next_state = (IN == 1'b0) ? 3'd3 : 3'd1;
            3'd3: next_state = (IN == 1'b1) ? 3'd4 : 3'd0;
            3'd4: next_state = (IN == 1'b1) ? 3'd5 : 3'd2;
            3'd5: next_state = (IN == 1'b1) ? 3'd1 : 3'd2;
            default: next_state = 3'd0;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= 3'd0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH asserted when state is 4 and IN=1 (Mealy output)
            MATCH <= (state == 3'd4) && (IN == 1'b1);
        end
    end

endmodule