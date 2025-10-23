module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// Simplified state definitions
localparam [1:0]
    IDLE    = 2'b00,
    GOT1    = 2'b01,
    GOT10   = 2'b10;

reg [1:0] current_state, next_state;

// State register
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic - simplified
always @(*) begin
    case (current_state)
        IDLE:  next_state = IN ? GOT1 : IDLE;
        GOT1:  next_state = IN ? GOT1 : GOT10;
        GOT10: next_state = IN ? (IN ? GOT1 : GOT10) : GOT10;
        default: next_state = IDLE;
    endcase
end

// Combinational Mealy output
assign MATCH = (current_state == GOT10) && IN;

endmodule