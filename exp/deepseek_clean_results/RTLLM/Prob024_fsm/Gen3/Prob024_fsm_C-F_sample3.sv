module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// Binary encoded states (3 bits for 5 states)
parameter IDLE    = 3'b000;
parameter GOT1    = 3'b001;
parameter GOT10   = 3'b010;
parameter GOT100  = 3'b011;
parameter GOT1001 = 3'b100;

reg [2:0] current_state, next_state;

// State transition and reset logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic with overlap handling
always @(*) begin
    case (current_state)
        IDLE:    next_state = IN ? GOT1 : IDLE;
        GOT1:    next_state = IN ? GOT1 : GOT10;
        GOT10:   next_state = IN ? GOT1 : GOT100;
        GOT100:  next_state = IN ? GOT1001 : IDLE;
        GOT1001: next_state = IN ? GOT1 : GOT10;  // After match, handle overlap
        default:  next_state = IDLE;
    endcase
end

// Mealy output - combinatorial but properly synchronized
assign MATCH = (current_state == GOT1001) && IN;

endmodule