module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states
typedef enum logic [2:0] {
    S0 = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100,
    S5 = 3'b101
} state_t;

// State registers
state_t current_state, next_state;

// State transition logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        S0: next_state = IN ? S1 : S0;
        S1: next_state = IN ? S1 : S2;
        S2: next_state = IN ? S1 : S3;
        S3: next_state = IN ? S4 : S0;
        S4: next_state = IN ? S5 : S2;
        S5: next_state = IN ? S1 : S2;
        default: next_state = S0;
    endcase
end

// Output logic (Mealy style - depends on current state and input)
always @(*) begin
    case (current_state)
        S4: MATCH = IN ? 1'b1 : 1'b0;  // Only match when we're in S4 and get 1
        default: MATCH = 1'b0;
    endcase
end

endmodule