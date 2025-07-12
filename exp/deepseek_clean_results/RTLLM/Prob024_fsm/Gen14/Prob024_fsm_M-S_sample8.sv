module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// Simplified state encoding (2 bits for 3 states)
localparam [1:0]
    IDLE   = 2'b00,
    S1     = 2'b01,
    S10    = 2'b10;

reg [1:0] state, next_state;

// State update only
always @(posedge CLK) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Simplified next state logic
always @(*) begin
    case (state)
        IDLE:   next_state = IN ? S1 : IDLE;
        S1:     next_state = IN ? S1 : S10;
        S10:    next_state = IN ? (IN ? S1 : IDLE) : S10;
        default: next_state = IDLE;
    endcase
end

// Combinational Mealy output
assign MATCH = (state == S10) && (IN == 1'b1);

endmodule