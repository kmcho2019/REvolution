module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// State encoding
parameter IDLE   = 2'b00;
parameter GOT1   = 2'b01;
parameter GOT10  = 2'b10;
parameter GOT100 = 2'b11;

reg [1:0] current_state, next_state;

// Output is combinational based on current state and input
assign MATCH = (current_state == GOT100) && IN;

// State transition logic
always @(posedge CLK or posedge RST) begin
    if (RST)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:   next_state = IN ? GOT1 : IDLE;
        GOT1:   next_state = IN ? GOT1 : GOT10;
        GOT10:  next_state = IN ? GOT1 : GOT100;
        GOT100: next_state = IDLE; // Always return to IDLE after GOT100
    endcase
end

endmodule