module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// State encoding remains the same
parameter [1:0]
    IDLE    = 2'b00,
    GOT1    = 2'b01,
    GOT10   = 2'b10,
    GOT100  = 2'b11;

reg [1:0] current_state, next_state;

// Combinational Mealy output
assign MATCH = (current_state == GOT100) && IN;

// Compact next state logic using ternary operators
always @(*) begin
    next_state = current_state; // Default: stay in current state
    case (current_state)
        IDLE:   next_state = IN ? GOT1 : IDLE;
        GOT1:   next_state = IN ? GOT1 : GOT10;
        GOT10:  next_state = IN ? GOT1 : GOT100;
        GOT100: next_state = IN ? GOT1 : GOT10;
    endcase
end

// Sequential state update only
always @(posedge CLK or posedge RST) begin
    if (RST) current_state <= IDLE;
    else    current_state <= next_state;
end

endmodule