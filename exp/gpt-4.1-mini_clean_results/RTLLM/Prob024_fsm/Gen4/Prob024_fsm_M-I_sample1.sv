module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

// Binary encoding of states (prefix matched length):
// S0: 0 - no match
// S1: 1 - matched '1'
// S2: 2 - matched '10'
// S3: 3 - matched '100'
// S4: 4 - matched '1001'
// S5: 5 - matched '10011' (final match state, but used transiently)
localparam [2:0]
    S0 = 3'd0,
    S1 = 3'd1,
    S2 = 3'd2,
    S3 = 3'd3,
    S4 = 3'd4,
    S5 = 3'd5;

reg [2:0] state, next_state;
wire match_comb;

// Next state logic for binary encoded FSM with pattern 1 0 0 1 1 (detect overlapping sequence)
always @(*) begin
    case(state)
        S0: next_state = IN ? S1 : S0;
        S1: next_state = IN ? S1 : S2;
        S2: next_state = IN ? S1 : S3;
        S3: next_state = IN ? S4 : S0;
        S4: next_state = IN ? S5 : S2;
        S5: next_state = IN ? S1 : S2;  // After match, loop to next possible prefix states
        default: next_state = S0;
    endcase
end

// Mealy output: MATCH asserted when current state is S4 and input is 1 (detecting final '1' in pattern)
assign match_comb = (state == S4) && (IN == 1'b1);

// Asynchronous reset, synchronous state update and MATCH register
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        MATCH <= match_comb;
    end
end

endmodule