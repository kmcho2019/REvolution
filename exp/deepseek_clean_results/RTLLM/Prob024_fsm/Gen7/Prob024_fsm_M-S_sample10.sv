module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State encoding (4 states)
parameter IDLE    = 2'b00;
parameter GOT1    = 2'b01;
parameter GOT10   = 2'b10;
parameter GOT100  = 2'b11;

reg [1:0] current_state, next_state;

// State transition
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:    next_state = IN ? GOT1 : IDLE;
        GOT1:    next_state = IN ? GOT1 : GOT10;
        GOT10:   next_state = IN ? GOT1 : GOT100;
        GOT100:  next_state = IN ? IDLE : IDLE;
    endcase
end

// Mealy output - combinational based on current state and input
always @(*) begin
    MATCH = (current_state == GOT100) && IN;
end

endmodule