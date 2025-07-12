module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// State encoding
parameter IDLE   = 2'b00;
parameter GOT1   = 2'b01;
parameter GOT00  = 2'b10;

reg [1:0] current_state, next_state;

// State transition
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:  next_state = IN ? GOT1 : IDLE;
        GOT1:  next_state = IN ? GOT1 : GOT00;
        GOT00: next_state = IN ? (MATCH ? GOT1 : IDLE) : GOT00;
        default: next_state = IDLE;
    endcase
end

// Output logic (Mealy)
assign MATCH = (current_state == GOT00) && IN;

endmodule