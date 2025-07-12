module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// Expanded binary encoded states (3 bits for 5 states)
parameter IDLE    = 3'b000;
parameter GOT1    = 3'b001;
parameter GOT10   = 3'b010;
parameter GOT100  = 3'b011;
parameter GOT1001 = 3'b100;

reg [2:0] current_state;
wire [2:0] next_state;

// Continuous assignments for next state logic
assign next_state = 
    (current_state == IDLE)    ? (IN ? GOT1 : IDLE) :
    (current_state == GOT1)    ? (IN ? GOT1 : GOT10) :
    (current_state == GOT10)   ? (IN ? GOT1 : GOT100) :
    (current_state == GOT100)  ? (IN ? GOT1001 : IDLE) :
    (current_state == GOT1001) ? (IN ? GOT1 : GOT10) :
    IDLE; // Default case

// Continuous assignment for Mealy output
wire comb_match = (current_state == GOT1001) && IN;

// Sequential logic for state and output registration
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        MATCH <= comb_match;
    end
end

endmodule