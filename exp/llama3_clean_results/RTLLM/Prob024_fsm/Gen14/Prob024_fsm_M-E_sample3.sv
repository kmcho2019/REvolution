module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4,
    MATCH_STATE
} state, next_state;

// Current state register
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state and output
always_comb begin
    next_state = state; // Default: stay in current state
    MATCH = 1'b0; // Default: no match

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
                next_state = IDLE; // Reset if unexpected '1'
            end
        end
        S2: begin
            if (!IN) begin
                next_state = S3;
            end else begin
                next_state = IDLE; // Reset if unexpected '1'
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
            end else begin
                next_state = IDLE; // Reset if unexpected '0'
            end
        end
        S4: begin
            if (IN) begin
                next_state = MATCH_STATE;
            end else begin
                next_state = IDLE; // Reset if unexpected '0'
            end
        end
        MATCH_STATE: begin
            MATCH = 1'b1; // Assert MATCH
            next_state = IDLE; // Transition back to IDLE after match
        end
        default: next_state = IDLE;
    endcase
end

endmodule