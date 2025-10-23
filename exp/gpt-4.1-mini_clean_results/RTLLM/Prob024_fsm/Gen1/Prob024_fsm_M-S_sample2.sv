module fsm(
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// States for sequence detection of "1 0 0 1 1"
typedef enum logic [2:0] {
    S0 = 3'd0,  // no match
    S1 = 3'd1,  // matched '1'
    S2 = 3'd2,  // matched '10'
    S3 = 3'd3,  // matched '100'
    S4 = 3'd4   // matched '1001'
} state_t;

state_t state, next_state;

always @(*) begin
    case (state)
        S0: next_state = (IN == 1'b1) ? S1 : S0;
        S1: next_state = (IN == 1'b0) ? S2 : S1;
        S2: next_state = (IN == 1'b0) ? S3 : (IN == 1'b1) ? S1 : S0;
        S3: next_state = (IN == 1'b1) ? S4 : S0;
        S4: next_state = (IN == 1'b1) ? S1 : (IN == 1'b0) ? S2 : S0;
        default: next_state = S0;
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        // MATCH is 1 only when in state S4 and IN==1 (final bit of sequence)
        MATCH <= (state == S4 && IN == 1'b1) ? 1'b1 : 1'b0;
    end
end

endmodule