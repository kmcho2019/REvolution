module fsm (
    input wire CLK,
    input wire RST,
    input wire IN,
    output wire MATCH
);

// Gray-coded state encoding for power efficiency
localparam [1:0]
    IDLE   = 2'b00,
    GOT1   = 2'b01,
    GOT10  = 2'b11,
    GOT100 = 2'b10;

reg [1:0] current_state, next_state;
reg IN_reg;

// Pipeline register for IN to improve timing
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        IN_reg <= 1'b0;
    end
    else begin
        current_state <= next_state;
        IN_reg <= IN;
    end
end

// Pure Mealy output (combinational)
assign MATCH = (current_state == GOT100) & IN;

// Next state logic (optimized)
always @(*) begin
    case (current_state)
        IDLE:   next_state = IN ? GOT1 : IDLE;
        GOT1:   next_state = IN ? GOT1 : GOT10;
        GOT10:  next_state = IN ? IDLE : GOT100;
        GOT100: next_state = IN ? GOT1 : IDLE;
    endcase
end

endmodule