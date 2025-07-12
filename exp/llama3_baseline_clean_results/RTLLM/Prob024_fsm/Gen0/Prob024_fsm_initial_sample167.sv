module fsm(
    input   logic   IN,       // Input signal to the FSM
    input   logic   CLK,      // Clock signal
    input   logic   RST,      // Reset signal
    output  logic   MATCH     // Output signal indicating a match
);

// Define the states of the FSM
typedef enum logic [2:0] {
    IDLE  = 3'b000,
    S1    = 3'b001,
    S2    = 3'b010,
    S3    = 3'b011,
    S4    = 3'b100,
    S5    = 3'b101
} state_t;

// Internal state register
state_t current_state;
state_t next_state;

// Output logic
assign MATCH = (current_state == S5);

// Next state logic
always_comb begin
    case (current_state)
        IDLE: begin
            if (IN == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (IN == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = IDLE; // Reset sequence if not matched
            end
        end
        S2: begin
            if (IN == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = IDLE; // Reset sequence if not matched
            end
        end
        S3: begin
            if (IN == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE; // Reset sequence if not matched
            end
        end
        S4: begin
            if (IN == 1'b1) begin
                next_state = S5;
            end else begin
                next_state = IDLE; // Reset sequence if not matched
            end
        end
        S5: begin
            next_state = IDLE; // After match, reset to IDLE
        end
        default: next_state = IDLE;
    endcase
end

// State register
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

endmodule