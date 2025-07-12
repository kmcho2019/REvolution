module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// One-hot state encoding
parameter IDLE    = 4'b0001;
parameter GOT1    = 4'b0010;
parameter GOT10   = 4'b0100;
parameter GOT100  = 4'b1000;

reg [3:0] current_state, next_state;

// Continuous output assignment
assign MATCH = (current_state == GOT100) && IN;

// State transition logic
always @(*) begin
    next_state = IDLE; // Default
    case (1'b1) // Parallel case
        current_state[0]: // IDLE
            next_state = IN ? GOT1 : IDLE;
        current_state[1]: // GOT1
            next_state = IN ? GOT1 : GOT10;
        current_state[2]: // GOT10
            next_state = IN ? GOT1 : GOT100;
        current_state[3]: // GOT100
            next_state = IN ? GOT1 : GOT10;
    endcase
end

// State register
always @(posedge CLK or posedge RST) begin
    if (RST)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

endmodule