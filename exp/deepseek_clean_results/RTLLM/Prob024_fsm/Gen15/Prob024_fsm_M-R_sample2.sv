module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// State encoding - 3 bits allows up to 8 states
parameter [2:0] S_IDLE    = 3'b000;
parameter [2:0] S_GOT1    = 3'b001;
parameter [2:0] S_GOT10   = 3'b010;
parameter [2:0] S_GOT100  = 3'b011;
parameter [2:0] S_GOT1001 = 3'b100;

reg [2:0] state;

// Synchronous state transition and reset logic
always @(posedge CLK) begin
    if (RST) begin
        state <= S_IDLE;
    end else begin
        case (state)
            S_IDLE:    state <= IN ? S_GOT1    : S_IDLE;
            S_GOT1:    state <= IN ? S_GOT1    : S_GOT10;
            S_GOT10:   state <= IN ? S_GOT1    : S_GOT100;
            S_GOT100:  state <= IN ? S_GOT1001 : S_IDLE;
            S_GOT1001: state <= IN ? S_GOT1    : S_GOT10;
        endcase
    end
end

// Mealy output - purely combinational
assign MATCH = (state == S_GOT1001) && IN;

endmodule