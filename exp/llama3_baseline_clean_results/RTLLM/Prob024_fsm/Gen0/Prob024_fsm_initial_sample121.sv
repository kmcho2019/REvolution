module fsm(
    input IN,  // Input signal to the FSM
    input CLK, // Clock signal used for synchronous operation
    input RST, // Reset signal to initialize the FSM
    output MATCH  // Output signal indicating a match condition based on the FSM state
);

// Define states for the sequence detection
typedef enum logic [2:0] {
    IDLE = 3'b001,  // Initial state
    S1 = 3'b010,   // First '1' detected
    S2 = 3'b011,   // First '0' after '1'
    S3 = 3'b100,   // Second '0'
    S4 = 3'b101,   // First '1' after '00'
    S5 = 3'b110    // Second '1' after '00', match condition
} state_t;

state_t current_state, next_state;

// Output logic for MATCH
assign MATCH = (current_state == S5);

// Sequential logic for state transitions
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Combinatorial logic for next state determination
always_comb begin
    case (current_state)
        IDLE: begin
            if (IN) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (!IN) begin
                next_state = S2;
            end else begin
                next_state = S1; // Not part of the target sequence, reset to S1
            end
        end
        S2: begin
            if (!IN) begin
                next_state = S3;
            end else begin
                next_state = S1; // Deviation, restart from S1
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
            end else begin
                next_state = S3; // Not part of the target sequence, stay in S3
            end
        end
        S4: begin
            if (IN) begin
                next_state = S5;
            end else begin
                next_state = IDLE; // Deviation, restart
            end
        end
        S5: begin
            if (IN) begin
                next_state = S1; // Match found, restart from S1 for continuous detection
            end else begin
                next_state = IDLE; // Match found, reset for new sequence detection
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule