module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// State encoding (binary):
// 0: no match
// 1: matched '1'
// 2: matched '10'
// 3: matched '100'
// 4: matched '1001'
// 5: matched '10011' (final match state)

reg [2:0] state, next_state;
wire match_comb;

// Next state logic with overlap handling for "10011"
always @(*) begin
    case(state)
        3'd0: next_state = IN ? 3'd1 : 3'd0;
        3'd1: next_state = IN ? 3'd1 : 3'd2;
        3'd2: next_state = IN ? 3'd1 : 3'd3;
        3'd3: next_state = IN ? 3'd4 : 3'd0;
        3'd4: next_state = IN ? 3'd5 : 3'd2;
        3'd5: next_state = IN ? 3'd1 : 3'd2; // After match, continue detecting overlapping sequences
        default: next_state = 3'd0;
    endcase
end

// Mealy output: MATCH = 1 when current input completes pattern ("10011")
// This occurs when in state 4 and input is 1 (transition to state 5)
assign match_comb = (state == 3'd4) && (IN == 1'b1);

// Synchronous state and output update
always @(posedge CLK) begin
    if (RST) begin
        state <= 3'd0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        MATCH <= match_comb;
    end
end

endmodule