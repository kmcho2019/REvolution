module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// State encoding with localparam
localparam [2:0]
    IDLE   = 3'b000,
    S1     = 3'b001,
    S10    = 3'b010,
    S100   = 3'b011,
    S1001  = 3'b100,
    S10011 = 3'b101;

reg [2:0] state;

// Combined state register and next state logic
always @(posedge CLK) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE:   state <= IN ? S1 : IDLE;
            S1:     state <= IN ? S1 : S10;
            S10:    state <= IN ? S1 : S100;
            S100:   state <= IN ? S1001 : IDLE;
            S1001:  state <= IN ? S10011 : S10;
            S10011: state <= IN ? S1 : S10;
        endcase
    end
end

// Continuous assignment for Mealy output
assign MATCH = (state == S1001) && IN;

endmodule