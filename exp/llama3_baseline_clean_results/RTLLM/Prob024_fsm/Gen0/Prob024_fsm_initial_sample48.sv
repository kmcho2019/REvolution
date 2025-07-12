module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Define the states of the FSM
enum logic [2:0] {
    S_IDLE = 3'b000,  // Initial state
    S_1    = 3'b001,  // State after seeing first '1'
    S_10   = 3'b010,  // State after seeing '10'
    S_100  = 3'b011,  // State after seeing '100'
    S_1001 = 3'b100,  // State after seeing '1001'
    S_MATCH = 3'b101  // State after seeing '10011'
} state, next_state;

// Assign the output signal MATCH based on the current state
always_comb begin
    MATCH = (state == S_MATCH);
end

// Define the state transition logic
always_comb begin
    case (state)
        S_IDLE: begin
            if (IN) begin
                next_state = S_1;
            end else begin
                next_state = S_IDLE;
            end
        end
        S_1: begin
            if (!IN) begin
                next_state = S_10;
            end else begin
                next_state = S_1;
            end
        end
        S_10: begin
            if (!IN) begin
                next_state = S_100;
            end else begin
                next_state = S_1;
            end
        end
        S_100: begin
            if (IN) begin
                next_state = S_1001;
            end else begin
                next_state = S_100;
            end
        end
        S_1001: begin
            if (IN) begin
                next_state = S_MATCH;
            end else begin
                next_state = S_IDLE;
            end
        end
        S_MATCH: begin
            if (IN) begin
                next_state = S_1;
            end else begin
                next_state = S_IDLE;
            end
        end
        default: next_state = S_IDLE;
    endcase
end

// Update the state on the positive edge of the clock or reset
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S_IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule