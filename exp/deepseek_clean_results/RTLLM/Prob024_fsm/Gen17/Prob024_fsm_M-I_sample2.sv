module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// One-hot encoded states (4 states)
parameter IDLE    = 4'b0001;
parameter GOT1    = 4'b0010;
parameter GOT10   = 4'b0100;
parameter GOT100  = 4'b1000;

reg [3:0] current_state, next_state;
reg IN_prev;  // For input change detection

// State transition and output logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
        IN_prev <= 1'b0;
    end else begin
        IN_prev <= IN;
        current_state <= next_state;
        // Registered output - set when previous state was GOT100 and IN is 1
        MATCH <= (current_state == GOT100) && IN;
    end
end

// Next state logic (only update if input changed)
always @(*) begin
    if (IN == IN_prev) begin
        next_state = current_state;  // No change if input stable
    end else begin
        case (current_state)
            IDLE:    next_state = IN ? GOT1 : IDLE;
            GOT1:    next_state = IN ? GOT1 : GOT10;
            GOT10:   next_state = IN ? GOT1 : GOT100;
            GOT100:  next_state = IN ? GOT1 : GOT10;
            default: next_state = IDLE;
        endcase
    end
end

endmodule