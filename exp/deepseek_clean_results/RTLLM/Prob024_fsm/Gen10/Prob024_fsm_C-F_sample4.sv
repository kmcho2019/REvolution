module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output wire MATCH
);

// State encoding - binary with clear names
localparam [2:0]
    IDLE    = 3'b000,
    GOT1    = 3'b001,
    GOT10   = 3'b010,
    GOT100  = 3'b011,
    GOT1001 = 3'b100;

reg [2:0] current_state, next_state;

// Synchronous state update with reset
always @(posedge CLK or posedge RST) begin
    if (RST)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// Optimized next-state logic with complete coverage
always @(*) begin
    case (current_state)
        IDLE:    next_state = IN ? GOT1 : IDLE;
        GOT1:    next_state = IN ? GOT1 : GOT10;
        GOT10:   next_state = IN ? IDLE : GOT100;
        GOT100:  next_state = IN ? GOT1001 : IDLE;
        GOT1001: next_state = IN ? GOT1 : GOT10;  // After match, continue detection
        default: next_state = IDLE;
    endcase
end

// Mealy output - active only when in GOT1001 state and IN=1
assign MATCH = (current_state == GOT1001) && IN;

endmodule