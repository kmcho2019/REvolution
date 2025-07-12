module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// State definitions
localparam [1:0] IDLE   = 2'b00;
localparam [1:0] GOT1   = 2'b01;
localparam [1:0] GOT10  = 2'b10;
localparam [1:0] GOT100 = 2'b11;

reg [1:0] current_state, next_state;

// State transition logic
always @(*) begin
    case (current_state)
        IDLE:   next_state = IN ? GOT1 : IDLE;
        GOT1:   next_state = IN ? GOT1 : GOT10;
        GOT10:  next_state = IN ? GOT1 : GOT100;
        GOT100: next_state = IN ? GOT1 : GOT10;
        default: next_state = IDLE;
    endcase
end

// State register
always @(posedge CLK or posedge RST) begin
    if (RST) current_state <= IDLE;
    else current_state <= next_state;
end

// Mealy output - combinational
assign MATCH = (current_state == GOT100) && IN;

endmodule