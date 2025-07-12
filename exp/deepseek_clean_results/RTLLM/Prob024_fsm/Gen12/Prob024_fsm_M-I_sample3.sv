module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// 3-bit encoding for 5 states (only 3 needed, but room for expansion)
parameter IDLE    = 3'b000;
parameter GOT1    = 3'b001;
parameter GOT10   = 3'b010;
parameter GOT100  = 3'b011;
parameter GOT1001 = 3'b100;

reg [2:0] current_state, next_state;
wire clk_enable = (current_state != IDLE) || IN; // Clock gating condition

// State transition and reset logic with clock gating
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else if (clk_enable) begin
        current_state <= next_state;
        // Registered output
        MATCH <= (current_state == GOT1001) && IN;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:    next_state = IN ? GOT1 : IDLE;
        GOT1:    next_state = IN ? GOT1 : GOT10;
        GOT10:   next_state = IN ? GOT1 : GOT100;
        GOT100:  next_state = IN ? GOT1001 : IDLE;
        GOT1001: next_state = IN ? GOT1 : GOT10;
        default: next_state = IDLE;
    endcase
end

endmodule