module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State encoding with clear names and compact representation
parameter [1:0]
    IDLE    = 2'b00,
    GOT1    = 2'b01,
    GOT10   = 2'b10,
    GOT100  = 2'b11;

reg [1:0] current_state, next_state;

// Combined state and output update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        // Registered Mealy output for better timing
        MATCH <= (current_state == GOT100) && IN;
    end
end

// Optimized next state logic
always @(*) begin
    case (current_state)
        IDLE:    next_state = IN ? GOT1 : IDLE;
        GOT1:    next_state = IN ? GOT1 : GOT10;
        GOT10:   next_state = IN ? GOT1 : GOT100;
        GOT100:  next_state = IN ? GOT1 : GOT10;  // Continuous detection
    endcase
end

endmodule