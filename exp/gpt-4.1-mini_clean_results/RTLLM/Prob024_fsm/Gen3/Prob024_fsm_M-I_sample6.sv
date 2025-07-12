module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// One-hot encoding of states representing prefix matched length:
// S0: no match (initial)
// S1: matched '1'
// S2: matched '10'
// S3: matched '100'
// S4: matched '1001'
// S5: matched '10011' (final match state, transitions back)

// State encoding: 6 bits, only one bit high per state
localparam S0 = 6'b000001,
           S1 = 6'b000010,
           S2 = 6'b000100,
           S3 = 6'b001000,
           S4 = 6'b010000,
           S5 = 6'b100000;

reg [5:0] state, next_state;
wire match_comb;

// Next state logic based on current state and input IN
always @(*) begin
    case(state)
        S0: next_state = IN ? S1 : S0;
        S1: next_state = IN ? S1 : S2;
        S2: next_state = IN ? S1 : S3;
        S3: next_state = IN ? S4 : S0;
        S4: next_state = IN ? S5 : S2;
        S5: next_state = IN ? S1 : S2;
        default: next_state = S0;
    endcase
end

// Combinational MATCH output assertion: Mealy output active when receiving last bit '1' of pattern
// That corresponds to transitioning into S5 with IN=1, or equivalently being in S4 and input=1 (because S5 is only a transient state to indicate match)
assign match_comb = (state == S4) && (IN == 1'b1);

// Synchronous state and MATCH update
always @(posedge CLK) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        MATCH <= match_comb;
    end
end

endmodule