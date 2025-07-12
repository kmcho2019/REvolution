module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// State definitions
localparam [2:0] IDLE    = 3'b000;
localparam [2:0] GOT1    = 3'b001;
localparam [2:0] GOT10   = 3'b010;
localparam [2:0] GOT100  = 3'b011;
localparam [2:0] GOT1001 = 3'b100;

reg [2:0] state;

// State transitions
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE:    state <= IN ? GOT1 : IDLE;
            GOT1:    state <= IN ? GOT1 : GOT10;
            GOT10:   state <= IN ? GOT1 : GOT100;
            GOT100:  state <= IN ? GOT1001 : GOT100;
            GOT1001: state <= IN ? GOT1 : GOT10;
            default: state <= IDLE;
        endcase
    end
end

// Mealy output - combinational
assign MATCH = (state == GOT1001) && IN;

endmodule