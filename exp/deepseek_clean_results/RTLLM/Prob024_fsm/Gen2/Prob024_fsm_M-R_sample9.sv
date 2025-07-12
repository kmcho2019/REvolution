module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// Binary encoded states (2 bits for 4 states)
parameter IDLE    = 2'b00;
parameter GOT1    = 2'b01;
parameter GOT10   = 2'b10;
parameter GOT100  = 2'b11;
parameter GOT1001 = 2'b00; // Shares encoding with IDLE but distinct in logic

reg [1:0] current_state, next_state;

// State transition and reset logic
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
        GOT100:  next_state = IN ? GOT1001 : IDLE;
        GOT1001: next_state = IN ? GOT1 : GOT10;
    endcase
end

// Mealy output - combinatorial
assign MATCH = (current_state == GOT1001) && IN && !RST;

endmodule