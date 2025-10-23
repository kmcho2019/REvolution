module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output wire MATCH
);

// State encoding
localparam [2:0] 
    IDLE   = 3'b000,
    S1     = 3'b001,
    S10    = 3'b010,
    S100   = 3'b011,
    S1001  = 3'b100;

reg [2:0] current_state, next_state;

// State register update (synchronous)
always @(posedge CLK or posedge RST) begin
    if (RST)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// Next state logic (combinational)
always @(*) begin
    case (current_state)
        IDLE:   next_state = IN ? S1 : IDLE;
        S1:     next_state = IN ? S1 : S10;
        S10:    next_state = IN ? IDLE : S100;
        S100:   next_state = IN ? S1001 : IDLE;
        S1001:  next_state = IN ? S1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// Output logic (Mealy style - continuous assignment)
assign MATCH = (current_state == S1001) && IN;

endmodule