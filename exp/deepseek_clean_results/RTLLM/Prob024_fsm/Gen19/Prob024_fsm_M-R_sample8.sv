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

reg [1:0] state;

// Combinational output assignment
assign MATCH = (state == GOT100) && IN;

// Single always block for state transitions
always @(posedge CLK) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE:    state <= IN ? GOT1 : IDLE;
            GOT1:    state <= IN ? GOT1 : GOT10;
            GOT10:   state <= IN ? GOT1 : GOT100;
            GOT100:  state <= IN ? GOT1 : GOT10;  // Continuous detection
        endcase
    end
end

endmodule