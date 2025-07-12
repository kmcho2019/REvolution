module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE = 3'b000,  // Initial state
    S1    = 3'b001,  // First '1' detected
    S2    = 3'b010,  // First '0' detected after '1'
    S3    = 3'b011,  // Second '0' detected
    S4    = 3'b100,  // First '1' detected after '00'
    S5    = 3'b101   // Second '1' detected, sequence complete
} state, next_state;

// Sequential logic for state transitions
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state and MATCH output
always_comb begin
    next_state = state;  // Default: stay in the same state
    MATCH = 1'b0;        // Default: no match

    case (state)
        IDLE: begin
            if (IN) begin
                next_state = S1;
            end
        end
        S1: begin
            if (!IN) begin
                next_state = S2;
            end else begin
                next_state = S1;  // Loop back to S1 if another '1' is received
            end
        end
        S2: begin
            if (!IN) begin
                next_state = S3;
            end else begin
                next_state = S1;  // Restart sequence if '1' is received
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
            end else begin
                next_state = S2;  // Stay in S3 if another '0' is received
            end
        end
        S4: begin
            if (IN) begin
                next_state = S5;
                MATCH = 1'b1;  // Set MATCH to 1 when sequence is complete
            end else begin
                next_state = S1;  // Restart sequence if '0' is received
            end
        end
        S5: begin
            if (IN) begin
                next_state = S5;  // Stay in S5, sequence already matched
            end else begin
                next_state = S1;  // Restart sequence if '0' is received
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule