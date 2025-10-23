module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State definitions with optimal encoding
localparam [1:0]
    IDLE   = 2'b00,
    GOT1   = 2'b01,
    GOT10  = 2'b10,
    GOT100 = 2'b11;

reg [1:0] current_state, next_state;
wire next_match;

// State register
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        MATCH <= next_match;
    end
end

// Next state logic (optimized)
always @(*) begin
    case (current_state)
        IDLE:   next_state = IN ? GOT1 : IDLE;
        GOT1:   next_state = IN ? GOT1 : GOT10;
        GOT10:  next_state = IN ? GOT1 : GOT100;
        GOT100: next_state = IN ? GOT1 : GOT10;  // After match, continue detection
        default: next_state = IDLE;
    endcase
end

// Combinational Mealy output
assign next_match = (current_state == GOT100) && IN;

endmodule