module fsm(
    input   logic       IN,      // Input signal to the FSM
    input   logic       CLK,     // Clock signal used for synchronous operation
    input   logic       RST,     // Reset signal to initialize the FSM
    output  logic       MATCH    // Output signal indicating a match condition based on the FSM state
);

// Define the FSM states
typedef enum logic [2:0] {
    S0,  // Initial state
    S1,  // State 1
    S2,  // State 2
    S3,  // State 3
    S4,  // State 4
    S5   // State 5
} state_t;

// Initialize the current state and next state
state_t current_state, next_state;

// FSM state transition logic
always_comb begin
    case (current_state)
        S0: begin
            if (IN) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (~IN) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (~IN) begin
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
            if (IN) begin
                next_state = S5;
                MATCH = 1'b1;
            end else begin
                next_state = S0;
                MATCH = 1'b0;
            end
        end
        default: begin
            next_state = S0;
        end
    endcase
end

// Synchronous reset and state update
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
    end
end

endmodule