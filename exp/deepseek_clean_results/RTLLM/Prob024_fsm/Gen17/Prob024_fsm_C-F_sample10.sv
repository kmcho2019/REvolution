module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// State definitions with optimal encoding
localparam [1:0]
    IDLE    = 2'b00,
    GOT1    = 2'b01,
    GOT10   = 2'b10,
    GOT100  = 2'b11;

reg [1:0] current_state, next_state;

// Combinational next state logic
always @(*) begin
    case (current_state)
        IDLE:   next_state = IN ? GOT1 : IDLE;
        GOT1:   next_state = IN ? GOT1 : GOT10;
        GOT10:  next_state = IN ? GOT1 : GOT100;
        GOT100: next_state = IN ? GOT1 : GOT10;
    endcase
end

// State register
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Mealy output (combinational)
wire mealy_match = (current_state == GOT100) && IN;

// Optional output register for better timing
reg match_reg;
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        match_reg <= 1'b0;
    end else begin
        match_reg <= mealy_match;
    end
end

// Choose between immediate or registered output
assign MATCH = mealy_match;  // For immediate Mealy response
// assign MATCH = match_reg; // For registered Mealy output

endmodule