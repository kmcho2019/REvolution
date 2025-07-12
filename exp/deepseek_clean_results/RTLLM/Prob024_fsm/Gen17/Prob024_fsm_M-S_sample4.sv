module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State definitions with reduced states
localparam [1:0]
    IDLE    = 2'b00,
    GOT1    = 2'b01,
    GOT10   = 2'b10;

reg [1:0] current_state, next_state;
wire next_match;

// State register and output update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        MATCH <= next_match;
    end
end

// Combinational next state logic
always @(*) begin
    case (current_state)
        IDLE:   next_state = IN ? GOT1 : IDLE;
        GOT1:   next_state = IN ? GOT1 : GOT10;
        GOT10:  next_state = IN ? GOT1 : GOT10; // Continuous detection
    endcase
end

// Combinational Mealy output - detects sequence 10011
assign next_match = (current_state == GOT10) && IN;

endmodule