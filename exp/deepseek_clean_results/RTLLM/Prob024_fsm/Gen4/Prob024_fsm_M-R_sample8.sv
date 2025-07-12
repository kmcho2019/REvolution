module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output wire MATCH
);

// State encoding
typedef enum logic [1:0] {
    IDLE = 2'b00,
    S1   = 2'b01,
    S10  = 2'b10,
    S100 = 2'b11
} state_t;

state_t current_state, next_state;

// State transition logic (combinational)
always_comb begin
    case (current_state)
        IDLE: next_state = IN ? S1 : IDLE;
        S1:   next_state = IN ? S1 : S10;
        S10:  next_state = IN ? IDLE : S100;
        S100: next_state = IN ? S1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// State register (sequential)
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Output logic (combinational)
assign MATCH = (current_state == S100) && IN;

endmodule