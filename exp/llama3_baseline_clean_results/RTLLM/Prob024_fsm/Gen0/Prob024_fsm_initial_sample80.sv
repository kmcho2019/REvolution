module fsm(
    input  logic CLK,    // Clock signal
    input  logic RST,    // Reset signal
    input  logic IN,     // Input signal to the FSM
    output logic MATCH   // Output signal indicating a match condition
);

// Define the states of the FSM
typedef enum logic [2:0] {
    S0,  // Initial state
    S1,  // Waiting for the first '0'
    S2,  // Waiting for the second '0'
    S3,  // Waiting for the '1'
    S4,  // Waiting for the last '1'
    S5   // Output MATCH is '1'
} state_t;

// Current and next state variables
state_t current_state;
state_t next_state;

// Output logic
always_comb begin
    // Default output
    MATCH = 0;
    
    // Set MATCH to '1' when in state S5
    if (current_state == S5) begin
        MATCH = 1;
    end
end

// State transition logic
always_comb begin
    // Default next state
    next_state = current_state;
    
    // State transitions
    case (current_state)
        S0: begin
            if (IN) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (!IN) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (!IN) begin
                next_state = S3;
            end else begin
                next_state = S0;
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
            end else begin
                next_state = S0;
            end
        end
        S4: begin
            if (IN) begin
                next_state = S5;
            end else begin
                next_state = S0;
            end
        end
        S5: begin
            next_state = S0;
        end
    endcase
end

// Synchronous state update
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

endmodule