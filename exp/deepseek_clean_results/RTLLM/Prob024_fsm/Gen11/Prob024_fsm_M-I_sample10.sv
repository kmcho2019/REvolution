module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// Binary encoded states (2 bits for 4 states)
parameter IDLE    = 2'b00;
parameter GOT1    = 2'b01;
parameter GOT10   = 2'b10;
parameter GOT100  = 2'b11;

reg [1:0] current_state, next_state;
wire clk_gated;
reg match_comb;

// Clock gating for IDLE state
assign clk_gated = (current_state == IDLE && !IN && !RST) ? 1'b0 : CLK;

// State transition and reset logic
always @(posedge clk_gated or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        MATCH <= match_comb;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:    next_state = IN ? GOT1 : IDLE;
        GOT1:    next_state = IN ? GOT1 : GOT10;
        GOT10:   next_state = IN ? GOT1 : GOT100;
        GOT100:  next_state = IN ? GOT1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// Mealy output - combinatorial
always @(*) begin
    match_comb = (current_state == GOT100) && IN;
end

endmodule