module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Binary encoding for states (more compact than one-hot)
typedef enum logic [2:0] {
    IDLE = 3'b000,
    STATE_1 = 3'b001,
    STATE_2 = 3'b010,
    STATE_3 = 3'b011,
    STATE_4 = 3'b100
} state_t;

state_t state, next_state;

always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    next_state = state;
    MATCH = 1'b0;
    
    case (state)
        IDLE: begin
            if (IN) next_state = STATE_1;
        end
        STATE_1: begin
            if (!IN) next_state = STATE_2;
            else next_state = IDLE;
        end
        STATE_2: begin
            if (!IN) next_state = STATE_3;
            else next_state = IDLE;
        end
        STATE_3: begin
            if (IN) next_state = STATE_4;
            else next_state = IDLE;
        end
        STATE_4: begin
            if (IN) begin
                MATCH = 1'b1; // Directly set MATCH in STATE_4 when IN is 1
                next_state = IDLE;
            end else begin
                next_state = IDLE;
            end
        end
    endcase
end

endmodule