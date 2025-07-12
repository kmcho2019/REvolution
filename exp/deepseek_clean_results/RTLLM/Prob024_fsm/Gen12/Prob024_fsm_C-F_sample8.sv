module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// Optimal state encoding (2 bits for 4 states)
localparam [1:0]
    IDLE   = 2'b00,
    S1     = 2'b01,
    S10    = 2'b10,
    S100   = 2'b11;

reg [1:0] state, next_state;

// Combined state and output update
always @(posedge CLK) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        // Registered Mealy output for best timing
        MATCH <= (state == S100) && IN;
    end
end

// Optimized next state logic
always @(*) begin
    case (state)
        IDLE:   next_state = IN ? S1 : IDLE;
        S1:     next_state = IN ? S1 : S10;
        S10:    next_state = IN ? S1 : S100;
        S100:   next_state = IN ? S1 : S10;  // After match, look for next sequence
        default: next_state = IDLE;
    endcase
end

endmodule