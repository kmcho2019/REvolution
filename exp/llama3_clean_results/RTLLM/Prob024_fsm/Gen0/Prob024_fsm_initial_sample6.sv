module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

enum logic [2:0] {
    IDLE = 3'b001,
    STATE_1 = 3'b010,
    STATE_2 = 3'b011,
    STATE_3 = 3'b100,
    STATE_4 = 3'b101,
    MATCH_STATE = 3'b110
} state, next_state;

always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        if (state == MATCH_STATE) begin
            MATCH <= 1'b1;
        end else begin
            MATCH <= 1'b0;
        end
    end
end

always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (IN) begin
                next_state = STATE_1;
            end
        end
        STATE_1: begin
            if (!IN) begin
                next_state = STATE_2;
            end else begin
                next_state = IDLE; // Incorrect sequence, reset
            end
        end
        STATE_2: begin
            if (!IN) begin
                next_state = STATE_3;
            end else begin
                next_state = IDLE; // Incorrect sequence, reset
            end
        end
        STATE_3: begin
            if (IN) begin
                next_state = STATE_4;
            end else begin
                next_state = IDLE; // Incorrect sequence, reset
            end
        end
        STATE_4: begin
            if (IN) begin
                next_state = MATCH_STATE;
            end else begin
                next_state = IDLE; // Incorrect sequence, reset
            end
        end
        MATCH_STATE: begin
            next_state = IDLE; // After match, reset to idle
        end
    endcase
end

endmodule