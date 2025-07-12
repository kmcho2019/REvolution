module fsm(
    input IN,  // Input signal to the FSM
    input CLK, // Clock signal used for synchronous operation
    input RST, // Reset signal to initialize the FSM
    output MATCH  // Output signal indicating a match condition based on the FSM state
);

// Define states for the sequence 10011
typedef enum logic [2:0] {
    IDLE = 3'b000,  // Initial state
    STATE_1 = 3'b001,  // First '1'
    STATE_0_1 = 3'b010,  // First '0'
    STATE_0_2 = 3'b011,  // Second '0'
    STATE_1_2 = 3'b100,  // Second '1'
    STATE_1_3 = 3'b101   // Third '1', which indicates a full match
} state_t;

state_t current_state, next_state;

// Output logic
assign MATCH = (current_state == STATE_1_3) ? 1'b1 : 1'b0;

// Sequential logic
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic
always_comb begin
    case (current_state)
        IDLE: begin
            if (IN) begin
                next_state = STATE_1;
            end else begin
                next_state = IDLE;
            end
        end
        STATE_1: begin
            if (!IN) begin
                next_state = STATE_0_1;
            end else begin
                next_state = IDLE;  // Reset sequence if 1 is followed by another 1
            end
        end
        STATE_0_1: begin
            if (!IN) begin
                next_state = STATE_0_2;
            end else begin
                next_state = IDLE;  // Reset sequence if 0 is followed by 1
            end
        end
        STATE_0_2: begin
            if (IN) begin
                next_state = STATE_1_2;
            end else begin
                next_state = IDLE;  // Reset sequence if second 0 is followed by another 0
            end
        end
        STATE_1_2: begin
            if (IN) begin
                next_state = STATE_1_3;
            end else begin
                next_state = IDLE;  // Reset sequence if second 1 is followed by 0
            end
        end
        STATE_1_3: begin
            next_state = IDLE;  // After a match, reset to IDLE
        end
        default: next_state = IDLE;
    endcase
end

endmodule