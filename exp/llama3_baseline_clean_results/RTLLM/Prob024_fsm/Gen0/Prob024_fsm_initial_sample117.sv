module fsm(
    input IN,  // Input signal to the FSM
    input CLK,  // Clock signal used for synchronous operation
    input RST,  // Reset signal to initialize the FSM
    output reg MATCH  // Output signal indicating a match condition based on the FSM state
);

// Define states for the FSM
typedef enum logic [2:0] {
    S0,  // Initial state or reset state
    S1,  // State after seeing the first '1'
    S2,  // State after seeing '10'
    S3,  // State after seeing '100'
    S4,  // State after seeing '1001'
    S5   // State after seeing '10011' (match condition)
} state_t;

state_t current_state;  // Current state of the FSM

// Initialize the state machine
initial begin
    current_state = S0;
end

// Synchronous logic for the FSM
always @(posedge CLK or posedge RST) begin
    if (RST) begin  // Reset the FSM if RST is active
        current_state <= S0;
        MATCH <= 0;
    end else begin
        case (current_state)
            S0: begin
                if (IN) begin
                    current_state <= S1;
                end else begin
                    current_state <= S0;
                end
                MATCH <= 0;
            end
            S1: begin
                if (!IN) begin
                    current_state <= S2;
                end else begin
                    current_state <= S1;
                end
                MATCH <= 0;
            end
            S2: begin
                if (!IN) begin
                    current_state <= S3;
                end else begin
                    current_state <= S1;
                end
                MATCH <= 0;
            end
            S3: begin
                if (IN) begin
                    current_state <= S4;
                end else begin
                    current_state <= S2;
                end
                MATCH <= 0;
            end
            S4: begin
                if (IN) begin
                    current_state <= S5;
                    MATCH <= 1;
                end else begin
                    current_state <= S0;
                    MATCH <= 0;
                end
            end
            S5: begin
                if (IN) begin
                    current_state <= S1;
                end else begin
                    current_state <= S0;
                end
                MATCH <= 0;
            end
            default: begin
                current_state <= S0;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule