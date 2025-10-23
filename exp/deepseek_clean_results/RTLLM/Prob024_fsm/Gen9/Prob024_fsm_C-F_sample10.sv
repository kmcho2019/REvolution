module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// State encoding - 3-bit binary for optimal balance of area and clarity
localparam [2:0] 
    IDLE   = 3'b000,
    S1     = 3'b001,
    S10    = 3'b010,
    S100   = 3'b011,
    S1001  = 3'b100;

reg [2:0] current_state, next_state;

// Synchronous state update with reset
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        // Mealy output - depends on current state AND input
        MATCH <= (current_state == S1001) && IN;
    end
end

// Optimized next-state logic
always @(*) begin
    case (current_state)
        IDLE:   next_state = IN ? S1 : IDLE;
        S1:     next_state = IN ? S1 : S10;
        S10:    next_state = IN ? S1 : S100;
        S100:   next_state = IN ? S1001 : IDLE;
        S1001:  next_state = IN ? S1 : S10;  // Efficient overlap handling
        default: next_state = IDLE;
    endcase
end

endmodule