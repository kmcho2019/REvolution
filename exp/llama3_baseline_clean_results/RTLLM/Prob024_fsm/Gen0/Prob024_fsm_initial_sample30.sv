module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define the states of the FSM
enum logic [2:0] {S0, S1, S2, S3, S4} state, next_state;

// Initialize the FSM
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 0;
    end else begin
        state <= next_state;
        case (state)
            S4: MATCH <= IN ? 1 : 0;
            default: MATCH <= 0;
        endcase
    end
end

// Define the state transitions
always_comb begin
    case (state)
        S0: next_state = IN ? S1 : S0;
        S1: next_state = IN ? S1 : S2;
        S2: next_state = IN ? S1 : (state == S2) ? S3 : S2;
        S3: next_state = IN ? S4 : S0;
        S4: next_state = IN ? S4 : S0;
        default: next_state = S0;
    endcase
end

endmodule