module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State encoding
parameter IDLE   = 2'b00;
parameter GOT1   = 2'b01;
parameter GOT10  = 2'b10;

reg [1:0] current_state, next_state;

// State transition and output logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Mealy output - direct assignment
        MATCH <= (current_state == GOT10) && IN;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:  next_state = IN ? GOT1 : IDLE;
        GOT1:  next_state = IN ? GOT1 : GOT10;
        GOT10: next_state = IN ? (IN ? GOT1 : IDLE) : IDLE;
        default: next_state = IDLE;
    endcase
end

endmodule