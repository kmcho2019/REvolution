module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// State encoding with explicit names
localparam [1:0]
    IDLE   = 2'b00,
    GOT1   = 2'b01,
    GOT10  = 2'b10,
    GOT100 = 2'b11;

reg [1:0] state;

// Mealy output - combinational based on current state and input
assign MATCH = (state == GOT100) && IN;

// State transitions
always @(posedge CLK) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE:   state <= IN ? GOT1 : IDLE;
            GOT1:   state <= IN ? GOT1 : GOT10;
            GOT10:  state <= IN ? GOT1 : GOT100;
            GOT100: state <= IN ? GOT1 : IDLE;
            default: state <= IDLE;
        endcase
    end
end

endmodule