module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// State definitions - reduced to 3 states
localparam [1:0]
    IDLE   = 2'b00,
    GOT1   = 2'b01,
    GOT10  = 2'b10;

reg [1:0] state;

// State register
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE:  state <= IN ? GOT1 : IDLE;
            GOT1:  state <= IN ? GOT1 : GOT10;
            GOT10: state <= IN ? GOT1 : IDLE;
        endcase
    end
end

// Combinational Mealy output
assign MATCH = (state == GOT10) && IN;

endmodule