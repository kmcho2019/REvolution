module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State encoding (2 bits for 4 states)
parameter IDLE    = 2'b00;
parameter GOT1    = 2'b01;
parameter GOT10   = 2'b10;
parameter GOT100  = 2'b11;

reg [1:0] current_state, next_state;
wire state_enable;

// State transition logic
always @(*) begin
    case (current_state)
        IDLE:    next_state = IN ? GOT1 : IDLE;
        GOT1:    next_state = IN ? GOT1 : GOT10;
        GOT10:   next_state = IN ? GOT1 : GOT100;
        GOT100:  next_state = IN ? IDLE : IDLE; // Will be overridden by output logic
        default: next_state = IDLE;
    endcase
end

// Clock gating enable - only update state when it will change
assign state_enable = (current_state != next_state) || RST;

// State register with clock gating
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else if (state_enable) begin
        current_state <= next_state;
    end
end

// Registered output logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        MATCH <= 1'b0;
    end else begin
        MATCH <= (current_state == GOT100) && IN;
    end
end

endmodule