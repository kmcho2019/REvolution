module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// Optimized state encoding with 2 bits for 5 states
localparam [1:0]
    IDLE   = 2'b00,
    S1     = 2'b01,
    S10    = 2'b10,
    S100   = 2'b11;
    
// Additional state tracking for S1001 using a separate bit
reg got_first_1;  // Tracks if we've seen the first '1' in S1001

reg [1:0] state, next_state;

// Combined state and output update with registered Mealy output
always @(posedge CLK) begin
    if (RST) begin
        state <= IDLE;
        got_first_1 <= 1'b0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        
        // Update got_first_1 flag
        if (state == S100 && IN)
            got_first_1 <= 1'b1;
        else if (state != S100)
            got_first_1 <= 1'b0;
            
        // Registered Mealy output
        MATCH <= (state == S100) && got_first_1 && IN;
    end
end

// Next state logic (combinational)
always @(*) begin
    case (state)
        IDLE:   next_state = IN ? S1 : IDLE;
        S1:     next_state = IN ? S1 : S10;
        S10:    next_state = IN ? IDLE : S100;
        S100:   next_state = IN ? S100 : IDLE;  // Stay in S100 if IN=1 for S1001
        default: next_state = IDLE;
    endcase
end

endmodule