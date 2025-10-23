module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// Binary encoded states (2 bits for 4 states)
parameter IDLE   = 2'b00;
parameter GOT1   = 2'b01;
parameter GOT10  = 2'b10;
parameter GOT100 = 2'b11;

reg [1:0] state;

// State transition and reset logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE:   state <= IN ? GOT1 : IDLE;
            GOT1:   state <= IN ? GOT1 : GOT10;
            GOT10:  state <= IN ? GOT1 : GOT100;
            GOT100: state <= IN ? GOT1 : IDLE;
        endcase
    end
end

// Mealy output - combinatorial
assign MATCH = (state == GOT100) && IN;

endmodule