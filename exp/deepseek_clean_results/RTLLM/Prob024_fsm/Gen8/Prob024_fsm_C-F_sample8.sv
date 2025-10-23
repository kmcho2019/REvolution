module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// Optimized binary state encoding for 5 states
localparam [2:0]
    IDLE   = 3'b000,
    S1     = 3'b001,
    S10    = 3'b010,
    S100   = 3'b011,
    S1001  = 3'b100;

reg [2:0] state, next_state;

// Combined state and output update
always @(posedge CLK) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        // Registered Mealy output - matches exactly when last '1' is detected
        MATCH <= (state == S1001) && IN;
    end
end

// Next state logic (combinational)
always @(*) begin
    case (state)
        IDLE:   next_state = IN ? S1 : IDLE;
        S1:     next_state = IN ? S1 : S10;
        S10:    next_state = IN ? S1 : S100;
        S100:   next_state = IN ? S1001 : IDLE;
        S1001:  next_state = IN ? S1 : IDLE; // After match, restart detection
        default: next_state = IDLE;
    endcase
end

endmodule