module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Define states
enum logic [2:0] {
    IDLE = 3'b000,  // Initial state
    STATE_1 = 3'b001,  // Received the first '1'
    STATE_0 = 3'b010,  // Received the first '0'
    STATE_00 = 3'b011,  // Received the second '0'
    STATE_1001 = 3'b100,  // Received '1001'
    STATE_10011 = 3'b101  // Received '10011'
} state, next_state;

// Always block for sequential logic
always_ff @(posedge CLK or posedge RST) begin
    if (RST) state <= IDLE; // Reset to initial state
    else state <= next_state;
end

// Combinational logic for next state and output
always_comb begin
    next_state = state; // Default: stay in the same state
    MATCH = 1'b0; // Default: no match

    case(state)
        IDLE: begin
            if (IN) next_state = STATE_1;
        end
        STATE_1: begin
            if (!IN) next_state = STATE_0;
            else next_state = STATE_1; // Stay in STATE_1 if input is still '1'
        end
        STATE_0: begin
            if (!IN) next_state = STATE_00;
            else next_state = STATE_1; // Go back to STATE_1 if '1' is received
        end
        STATE_00: begin
            if (IN) next_state = STATE_1001;
            else next_state = IDLE; // Reset to IDLE if '0' is received again
        end
        STATE_1001: begin
            if (IN) begin
                next_state = STATE_10011;
                MATCH = 1'b1; // Set MATCH to 1 when the sequence is complete
            end
            else next_state = IDLE; // Reset to IDLE if '0' is received
        end
        STATE_10011: begin
            // This state is only reached when the sequence is detected
            // and we set MATCH to 1 in the previous state
            // We can either stay here or reset to IDLE based on the requirement
            if (IN) next_state = STATE_1; // Go back to STATE_1 if '1' is received again
            else next_state = IDLE; // Reset to IDLE
        end
        default: next_state = IDLE; // Invalid state, reset to IDLE
    endcase
end

endmodule