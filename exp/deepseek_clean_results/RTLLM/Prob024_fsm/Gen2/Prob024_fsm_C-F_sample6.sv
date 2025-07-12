module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// State encoding - binary for efficiency
typedef enum logic [2:0] {
    IDLE   = 3'b000,
    S1     = 3'b001,
    S10    = 3'b010,
    S100   = 3'b011,
    S1001  = 3'b100
} state_t;

// State registers
state_t current_state, next_state;

// State transition logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        // Registered output to improve timing
        MATCH <= (current_state == S1001) && IN;
    end
end

// Next state logic (combinational)
always @(*) begin
    case (current_state)
        IDLE:   next_state = IN ? S1 : IDLE;
        S1:     next_state = IN ? S1 : S10;
        S10:    next_state = IN ? S1 : S100;
        S100:   next_state = IN ? S1001 : IDLE;
        S1001:  next_state = IN ? S1 : S10;  // Handle overlap
        default: next_state = IDLE;
    endcase
end

endmodule