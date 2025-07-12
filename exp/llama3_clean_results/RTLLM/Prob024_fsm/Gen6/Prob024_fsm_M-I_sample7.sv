module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states using 3-bit binary encoding
typedef enum logic [2:0] {
    S0 = 3'b000, // Initial state
    S1 = 3'b001, // State after first '1'
    S2 = 3'b010, // State after first '0'
    S3 = 3'b011, // State after second '0'
    S4 = 3'b100, // State after third '1'
    S5 = 3'b101  // Final state (MATCH = 1)
} state_type;

reg state_type state; // Current state
reg state_type next_state; // Next state

// Combinational logic for next state
always @(*) begin
    case(state)
        S0: next_state = IN ? S1 : S0;
        S1: next_state = IN ? S1 : S2;
        S2: next_state = IN ? S1 : S3;
        S3: next_state = IN ? S4 : S3;
        S4: next_state = IN ? S5 : S2;
        S5: next_state = IN ? S5 : S2;
        default: next_state = S0;
    endcase
end

// Sequential logic for state update and output
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        MATCH <= (state == S5 && IN);
    end
end

endmodule