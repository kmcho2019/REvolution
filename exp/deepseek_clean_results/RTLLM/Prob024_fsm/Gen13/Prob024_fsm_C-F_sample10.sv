module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// State definitions with unique encoding
localparam [2:0] IDLE    = 3'b000;
localparam [2:0] GOT1    = 3'b001;
localparam [2:0] GOT10   = 3'b010;
localparam [2:0] GOT100  = 3'b011;
localparam [2:0] GOT1001 = 3'b100;

reg [2:0] current_state, next_state;

// State register with synchronous reset
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic - optimized progression
always @(*) begin
    case (current_state)
        IDLE:    next_state = IN ? GOT1 : IDLE;
        GOT1:    next_state = IN ? GOT1 : GOT10;
        GOT10:   next_state = IN ? GOT1 : GOT100;
        GOT100:  next_state = IN ? GOT1001 : IDLE;
        GOT1001: next_state = IN ? GOT1 : GOT10; // Immediate restart
        default: next_state = IDLE;
    endcase
end

// Dual output strategy for flexibility
wire comb_match = (current_state == GOT1001) && IN;
reg reg_match;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        reg_match <= 1'b0;
    end else begin
        reg_match <= comb_match;
    end
end

// Choose output type (commented options for flexibility)
assign MATCH = comb_match;  // Pure Mealy behavior
// assign MATCH = reg_match; // Registered output for better timing

endmodule