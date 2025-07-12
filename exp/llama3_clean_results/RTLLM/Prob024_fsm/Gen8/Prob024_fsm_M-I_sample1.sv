module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Binary encoding for the states
typedef enum logic [1:0] {
    IDLE = 2'b00,
    S1   = 2'b01,
    S2   = 2'b10,
    S3   = 2'b11
} state_type;

state_type state, next_state;

// Synchronous reset
always_ff @(posedge CLK) begin
    if (RST) begin
        state <= IDLE; // Reset to IDLE state
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    next_state = state; // Default: stay in the current state
    MATCH = 1'b0; // Default: no match

    case (state)
        IDLE: 
            if (IN) next_state = S1; // Transition to S1 on input 1
        S1: 
            if (~IN) next_state = S2; // Transition to S2 on input 0
        S2: 
            if (~IN) next_state = S2; // Stay in S2 on input 0
            else next_state = S3; // Transition to S3 on input 1
        S3: 
            if (IN) begin // On input 1, match and revert to IDLE
                next_state = IDLE;
                MATCH = 1'b1;
            end else next_state = IDLE; // Revert to IDLE on any other input
    endcase
end

endmodule