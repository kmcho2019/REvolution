module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// Gray-coded state definitions
localparam [1:0]
    IDLE   = 2'b00,
    GOT1   = 2'b01,
    GOT10  = 2'b11,
    GOT100 = 2'b10;

reg [1:0] current_state, next_state;

// Continuous output assignment
assign MATCH = (current_state == GOT100) && IN;

// State register
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
        GOT100: next_state = IN ? GOT1 : GOT100;
        default: next_state = IDLE;
    endcase
end

endmodule