module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// Define states with binary encoding
typedef enum logic [2:0] {
    IDLE   = 3'b000,
    S1     = 3'b001,
    S10    = 3'b010,
    S100   = 3'b011,
    S1001  = 3'b100
} state_t;

// State registers
state_t current_state, next_state;
reg next_match;

// State transition and output logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        // Clock gating for MATCH - only update when needed
        if (next_state == S1001 && IN) begin
            MATCH <= 1'b1;
        end else begin
            MATCH <= 1'b0;
        end
    end
end

// Combinational next state logic
always @(*) begin
    case (current_state)
        IDLE:   next_state = IN ? S1 : IDLE;
        S1:     next_state = !IN ? S10 : S1;
        S10:    next_state = !IN ? S100 : IDLE;
        S100:   next_state = IN ? S1001 : IDLE;
        S1001:  next_state = IN ? S1 : IDLE;
    endcase
end

endmodule