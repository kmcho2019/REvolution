module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// One-hot encoded states (5 states)
parameter IDLE    = 5'b00001;
parameter GOT1    = 5'b00010;
parameter GOT10   = 5'b00100;
parameter GOT100  = 5'b01000;
parameter GOT1001 = 5'b10000;

reg [4:0] current_state, next_state;
reg IN_sync, IN_prev;
wire comb_match;
wire clk_enable;

// Synchronizer for IN signal
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        IN_sync <= 1'b0;
        IN_prev <= 1'b0;
    end else begin
        IN_sync <= IN;
        IN_prev <= IN_sync;
    end
end

// Clock gating - only enable when input changes
assign clk_enable = (IN_sync != IN_prev) || RST;

// State transition and reset logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else if (clk_enable) begin
        current_state <= next_state;
        MATCH <= comb_match;
    end
end

// Next state logic
always @(*) begin
    next_state = IDLE; // Default
    case (current_state)
        IDLE:    next_state = IN_sync ? GOT1 : IDLE;
        GOT1:    next_state = IN_sync ? GOT1 : GOT10;
        GOT10:   next_state = IN_sync ? GOT1 : GOT100;
        GOT100:  next_state = IN_sync ? GOT1001 : IDLE;
        GOT1001: next_state = IN_sync ? GOT1 : GOT10;
        default: next_state = IDLE;
    endcase
end

// Optimized Mealy output
assign comb_match = (current_state == GOT1001) && IN_sync;

endmodule