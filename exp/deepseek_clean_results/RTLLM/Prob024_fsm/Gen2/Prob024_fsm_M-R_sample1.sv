module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// Consistent 3-bit state encoding
parameter [2:0] IDLE   = 3'b000,
                S1     = 3'b001,
                S10    = 3'b010,
                S100   = 3'b011,
                S1001  = 3'b100,
                S10011 = 3'b101;

reg [2:0] current_state, next_state;

// State transition logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:   next_state = IN ? S1 : IDLE;
        S1:     next_state = IN ? S1 : S10;
        S10:    next_state = IN ? S1 : S100;
        S100:   next_state = IN ? S1001 : IDLE;
        S1001:  next_state = IN ? S10011 : S10;
        S10011: next_state = IN ? S1 : S10; // After match, look for next sequence
        default: next_state = IDLE;
    endcase
end

// Mealy output - combinational logic
assign MATCH = (current_state == S1001 && IN) ||  // First '1' of "11"
               (current_state == S10011);         // Second '1' of "11"

endmodule