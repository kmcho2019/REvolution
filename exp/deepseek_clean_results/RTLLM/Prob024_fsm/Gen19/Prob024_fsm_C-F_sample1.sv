module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// Optimal state encoding with descriptive names
typedef enum logic [1:0] {
    IDLE,
    GOT1,
    GOT10,
    GOT100
} state_t;

state_t current_state, next_state;

// State register with synchronous reset
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        // Registered output for better timing
        MATCH <= (current_state == GOT100) && IN;
    end
end

// Optimized next state logic
always_comb begin
    case (current_state)
        IDLE:   next_state = IN ? GOT1 : IDLE;
        GOT1:   next_state = IN ? GOT1 : GOT10;
        GOT10:  next_state = IN ? GOT1 : GOT100;
        GOT100: next_state = IN ? GOT1 : GOT10;  // Immediate restart after match
        default: next_state = IDLE;
    endcase
end

endmodule