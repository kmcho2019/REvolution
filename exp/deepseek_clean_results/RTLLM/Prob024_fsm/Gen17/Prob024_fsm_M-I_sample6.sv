module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// Binary encoded states (3 bits for 5 states)
parameter IDLE    = 3'b000;
parameter GOT1    = 3'b001;
parameter GOT10   = 3'b010;
parameter GOT100  = 3'b011;
parameter GOT1001 = 3'b100;

reg [2:0] current_state, next_state;
reg clock_enable;

// Clock gating logic - only enable when state will change
always @(*) begin
    case (current_state)
        IDLE:    clock_enable = (IN == 1'b1);
        GOT1:    clock_enable = (IN == 1'b0);
        GOT10:   clock_enable = (IN == 1'b0);
        GOT100:  clock_enable = (IN == 1'b1);
        GOT1001: clock_enable = 1'b1; // Always enable for last state
        default: clock_enable = 1'b1;
    endcase
end

// State transition with clock gating
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else if (clock_enable) begin
        current_state <= next_state;
        // Registered output - set when in GOT1001 state and IN=1
        MATCH <= (next_state == GOT1001) && IN;
    end else begin
        MATCH <= 1'b0;
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