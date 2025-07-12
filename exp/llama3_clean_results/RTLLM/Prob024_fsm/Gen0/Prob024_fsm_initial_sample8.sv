module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Enumerate the states
enum logic [2:0] {
    S0 = 3'b000, // Initial state
    S1 = 3'b001, // Received the first '1'
    S2 = 3'b010, // Received the first '0'
    S3 = 3'b011, // Received the second '0'
    S4 = 3'b100  // Received the first '1' after the zeros
} state, next_state;

// Always block for combinational logic
always_comb begin
    next_state = state; // Default: stay in the current state
    MATCH = 1'b0; // Default: no match

    case(state)
        S0: begin
            if (IN == 1'b1) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if (IN == 1'b0) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            if (IN == 1'b0) next_state = S3;
            else if (IN == 1'b1) next_state = S1; // Incorrect sequence, restart
            else next_state = S2;
        end
        S3: begin
            if (IN == 1'b1) next_state = S4;
            else next_state = S0; // Incorrect sequence, restart
        end
        S4: begin
            if (IN == 1'b1) begin
                MATCH = 1'b1; // Match found
                next_state = S4; // Stay in S4 to continuously detect
            end
            else next_state = S0; // Sequence ended or incorrect, restart
        end
        default: next_state = S0; // Invalid state, reset to S0
    endcase
end

// Always block for sequential logic
always_ff @(posedge CLK or posedge RST) begin
    if (RST) state <= S0; // Reset to initial state
    else state <= next_state;
end

endmodule