module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// Binary encoded states with distinct codes
parameter IDLE    = 2'b00;
parameter GOT1    = 2'b01;
parameter GOT10   = 2'b10;
parameter GOT100  = 2'b11;
parameter GOT1001 = 2'b01;  // Distinct from GOT1 in logic flow

reg [1:0] current_state, next_state;

// State transition and output logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        // Registered Mealy output - checks current state and input
        MATCH <= (current_state == GOT1001) && IN;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:    next_state = IN ? GOT1 : IDLE;
        GOT1:    next_state = IN ? GOT1 : GOT10;
        GOT10:   next_state = IN ? GOT1 : GOT100;
        GOT100:  next_state = IN ? GOT1001 : IDLE;
        GOT1001: next_state = IN ? GOT1 : GOT10;
        default: next_state = IDLE;
    endcase
end

endmodule