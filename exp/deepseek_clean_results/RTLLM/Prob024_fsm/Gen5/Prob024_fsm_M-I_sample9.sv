module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// 3-bit encoding for 5 states (only 3 bits needed for future expansion)
parameter IDLE    = 3'b000;
parameter GOT1    = 3'b001;
parameter GOT10   = 3'b010;
parameter GOT100  = 3'b011;
parameter GOT1001 = 3'b100;

reg [2:0] current_state, next_state;

// State transition and reset logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        // Registered output - matches when we're in GOT1001 and see IN=1
        MATCH <= (current_state == GOT1001) && IN;
    end
end

// Next state logic with enable conditions
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