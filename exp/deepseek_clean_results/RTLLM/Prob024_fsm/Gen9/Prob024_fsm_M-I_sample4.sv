module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// One-hot state encoding for lower switching power
localparam [4:0] 
    IDLE   = 5'b00001,
    S1     = 5'b00010,
    S10    = 5'b00100,
    S100   = 5'b01000,
    S1001  = 5'b10000;

reg [4:0] current_state, next_state;
wire match_comb;

// Synchronous state update with reset
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end
    else begin
        current_state <= next_state;
        // Clock-gated MATCH register
        if (current_state == S1001)
            MATCH <= match_comb;
        else
            MATCH <= 1'b0;
    end
end

// Optimized next-state logic
always @(*) begin
    case (current_state)
        IDLE:   next_state = IN ? S1 : IDLE;
        S1:     next_state = IN ? S1 : S10;
        S10:    next_state = IN ? IDLE : S100;
        S100:   next_state = IN ? S1001 : IDLE;
        S1001:  next_state = IN ? S1 : IDLE;
    endcase
end

// Combinational match detection
assign match_comb = IN;

endmodule