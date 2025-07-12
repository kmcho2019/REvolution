module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State encoding - 3 bits for 5 states
parameter IDLE    = 3'b000;
parameter GOT1    = 3'b001;
parameter GOT10   = 3'b010;
parameter GOT100  = 3'b011;
parameter GOT1001 = 3'b100;

reg [2:0] current_state, next_state;
reg state_enable;  // Clock gating control

// State transition logic (combinational)
always @(*) begin
    case (current_state)
        IDLE:    next_state = IN ? GOT1 : IDLE;
        GOT1:    next_state = IN ? GOT1 : GOT10;
        GOT10:   next_state = IN ? GOT1 : GOT100;
        GOT100:  next_state = IN ? GOT1001 : IDLE;
        GOT1001: next_state = IN ? GOT1 : GOT10;
        default: next_state = IDLE;
    endcase
    
    // Clock gating - enable only when state changes
    state_enable = (next_state != current_state);
end

// State register with clock gating
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else if (state_enable) begin
        current_state <= next_state;
    end
end

// Output register with enable
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        MATCH <= 1'b0;
    end else begin
        MATCH <= (current_state == GOT1001) && IN;
    end
end

endmodule