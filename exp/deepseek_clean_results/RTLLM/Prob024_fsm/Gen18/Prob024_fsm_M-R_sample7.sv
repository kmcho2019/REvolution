module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// 3-bit encoding for 5 states
parameter IDLE    = 3'b000;
parameter GOT1    = 3'b001;
parameter GOT10   = 3'b010;
parameter GOT100  = 3'b011;
parameter GOT1001 = 3'b100;

reg [2:0] state;

// State transition and reset logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE:    state <= IN ? GOT1 : IDLE;
            GOT1:    state <= IN ? GOT1 : GOT10;
            GOT10:   state <= IN ? GOT1 : GOT100;
            GOT100:  state <= IN ? GOT1001 : IDLE;
            GOT1001: state <= IN ? GOT1 : GOT10;
        endcase
    end
end

// Mealy output - combinatorial
assign MATCH = (state == GOT100) && IN;

endmodule