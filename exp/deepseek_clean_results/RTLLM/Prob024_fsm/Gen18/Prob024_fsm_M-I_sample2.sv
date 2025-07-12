module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// 3-bit encoded states (5 states)
parameter IDLE    = 3'b000;
parameter GOT1    = 3'b001;
parameter GOT10   = 3'b010;
parameter GOT100  = 3'b011;
parameter GOT1001 = 3'b100;

reg [2:0] current_state, next_state;
reg state_enable;

// State transition enable logic
always @(*) begin
    case (current_state)
        IDLE:    state_enable = IN;  // Only enable if IN changes from 0
        GOT1:    state_enable = 1;   // Always enable (either stay or move)
        GOT10:   state_enable = 1;   // Always enable
        GOT100:  state_enable = IN;  // Only enable if IN=1
        GOT1001: state_enable = 1;   // Always enable
        default: state_enable = 1;
    endcase
end

// State transition and reset logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else if (state_enable) begin
        current_state <= next_state;
        // Registered output - set only when in GOT1001 state and IN=1
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
        default:  next_state = IDLE;
    endcase
end

endmodule