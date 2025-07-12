module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// One-hot encoding for states
enum logic [4:0] {
    IDLE = 5'b00001,
    STATE_1 = 5'b00010,
    STATE_2 = 5'b00100,
    STATE_3 = 5'b01000,
    STATE_4 = 5'b10000
} state, next_state;

// Clock gating enable signal
logic enable;

always_comb begin
    enable = 1'b1; // For simplicity, always enable, but in practice, this should be based on actual requirements
end

always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 1'b0;
    end else if (enable) begin
        state <= next_state;
    end
end

always_comb begin
    next_state = state;
    MATCH = 1'b0; // Default MATCH to 0
    
    case (1'b1) // Use one-hot encoding to simplify the case statement
        state[0]: begin // IDLE
            if (IN) begin
                next_state = STATE_1;
            end
        end
        state[1]: begin // STATE_1
            if (!IN) begin
                next_state = STATE_2;
            end else begin
                next_state = IDLE;
            end
        end
        state[2]: begin // STATE_2
            if (!IN) begin
                next_state = STATE_3;
            end else begin
                next_state = IDLE;
            end
        end
        state[3]: begin // STATE_3
            if (IN) begin
                next_state = STATE_4;
            end else begin
                next_state = IDLE;
            end
        end
        state[4]: begin // STATE_4
            if (IN) begin
                MATCH = 1'b1; // Set MATCH to 1 when in STATE_4 and IN is 1
                next_state = IDLE; // Transition back to IDLE
            end else begin
                next_state = IDLE;
            end
        end
    endcase
end

endmodule