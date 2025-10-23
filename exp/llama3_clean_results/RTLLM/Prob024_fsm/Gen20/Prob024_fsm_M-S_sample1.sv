module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

// Define states for sequence detection
typedef enum logic [2:0] {
    S0, // Initial state
    S1, // First '1'
    S2, // First '0'
    S3, // Second '0'
    S4, // Second '1'
    S5  // Second '1' (final state)
} state_type;

state_type state, next_state;

// State transition logic
always_comb begin
    case (state)
        S0: next_state = IN? S1 : S0;
        S1: next_state = ~IN? S2 : S0;
        S2: next_state = ~IN? S3 : S0;
        S3: next_state = IN? S4 : S0;
        S4: next_state = IN? S5 : S0;
        S5: next_state = S0; // Reset to initial state after match
        default: next_state = S0;
    endcase
end

// State register with reset
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0; // Reset state to initial
        MATCH <= 1'b0; // Reset MATCH signal
    end else begin
        state <= next_state; // Update state
        MATCH <= (state == S5)? 1'b1 : 1'b0; // Set MATCH signal on final state
    end
end

endmodule