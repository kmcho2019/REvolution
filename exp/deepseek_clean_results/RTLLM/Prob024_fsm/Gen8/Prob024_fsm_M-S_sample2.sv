module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State encoding (2 bits for 4 states)
parameter IDLE   = 2'b00;
parameter GOT1   = 2'b01;
parameter GOT10  = 2'b10;
parameter GOT100 = 2'b11;

reg [1:0] state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        case (state)
            IDLE:   state <= IN ? GOT1 : IDLE;
            GOT1:   state <= IN ? GOT1 : GOT10;
            GOT10:  state <= IN ? GOT1 : GOT100;
            GOT100: state <= IN ? (MATCH ? GOT1 : state) : GOT10;
        endcase
        
        // Mealy output: 1 only when in GOT100 state and IN is 1
        MATCH <= (state == GOT100) && IN;
    end
end

endmodule