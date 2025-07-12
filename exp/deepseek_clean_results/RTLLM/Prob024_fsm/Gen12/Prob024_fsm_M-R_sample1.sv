module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// State encoding using explicit bits
reg [1:0] state;
reg [1:0] next_state;

// State definitions via bit patterns
// IDLE = 00
// S1   = 01
// S10  = 10
// S100 = 11

// Combinational output (Mealy)
assign MATCH = (state == 2'b11) && IN;  // S100 state and IN=1

// State register
always @(posedge CLK) begin
    if (RST)
        state <= 2'b00;  // Reset to IDLE
    else
        state <= next_state;
end

// Next state logic
always @(*) begin
    case (state)
        2'b00: next_state = IN ? 2'b01 : 2'b00;  // IDLE
        2'b01: next_state = IN ? 2'b01 : 2'b10;  // S1
        2'b10: next_state = IN ? 2'b01 : 2'b11;  // S10
        2'b11: next_state = IN ? 2'b01 : 2'b00;  // S100
        default: next_state = 2'b00;
    endcase
end

endmodule