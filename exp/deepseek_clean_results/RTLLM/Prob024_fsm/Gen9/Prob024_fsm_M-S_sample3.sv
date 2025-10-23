module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// State encoding
localparam [1:0]
    IDLE   = 2'b00,
    S1     = 2'b01,
    S10    = 2'b10,
    S100   = 2'b11;

reg [1:0] state;

// State transition and storage
always @(posedge CLK) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE:   state <= IN ? S1 : IDLE;
            S1:     state <= IN ? S1 : S10;
            S10:    state <= IN ? S1 : S100;
            S100:   state <= IN ? S1 : IDLE;
            default: state <= IDLE;
        endcase
    end
end

// Combinational Mealy output
assign MATCH = (state == S100) && IN;

endmodule