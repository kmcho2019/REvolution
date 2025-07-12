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
wire comb_match;

// State register
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
        IDLE:   next_state = IN ? GOT1 : IDLE;
        GOT1:   next_state = IN ? GOT1 : GOT10;
        GOT10:  next_state = IN ? GOT1 : GOT100;
        GOT100: next_state = IN ? GOT1 : GOT10; // After match, restart detection
        default: next_state = IDLE;
    endcase
end

// Combinational Mealy output
assign comb_match = (current_state == GOT100) && IN;

// Output register for better timing
reg match_reg;
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        match_reg <= 1'b0;
    end else begin
        match_reg <= comb_match;
    end
end

assign MATCH = match_reg;

endmodule