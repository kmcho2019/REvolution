module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// Define states
typedef enum logic [2:0] {
    S0, // Initial state
    S1, // '1' detected
    S2, // '10' detected
    S3, // '100' detected
    S4  // '1001' detected
} state_t;

// State registers
state_t current_state, next_state;

// State transition and output logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        // Mealy output depends on current state and input
        case (current_state)
            S4: MATCH <= (IN == 1'b1) ? 1'b1 : 1'b0;
            default: MATCH <= 1'b0;
        endcase
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        S0: next_state = (IN == 1'b1) ? S1 : S0;
        S1: next_state = (IN == 1'b0) ? S2 : S1;
        S2: next_state = (IN == 1'b0) ? S3 : S1;
        S3: next_state = (IN == 1'b1) ? S4 : S0;
        S4: next_state = (IN == 1'b1) ? S1 : S2;
        default: next_state = S0;
    endcase
end

endmodule