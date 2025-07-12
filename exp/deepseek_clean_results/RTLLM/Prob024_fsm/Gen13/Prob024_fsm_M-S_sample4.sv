module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State encoding
parameter IDLE   = 2'b00;
parameter GOT1   = 2'b01;
parameter GOT10  = 2'b10;
parameter GOT100 = 2'b11;

reg [1:0] state;

// State transition and output logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE:   state <= IN ? GOT1 : IDLE;
            GOT1:   state <= IN ? GOT1 : GOT10;
            GOT10:  state <= IN ? GOT1 : GOT100;
            GOT100: state <= IN ? GOT1 : GOT10;
            default:state <= IDLE;
        endcase
    end
end

// Output is 1 when in GOT100 state and IN is 1 (Mealy output)
always @(*) begin
    MATCH = (state == GOT100) && IN;
end

endmodule