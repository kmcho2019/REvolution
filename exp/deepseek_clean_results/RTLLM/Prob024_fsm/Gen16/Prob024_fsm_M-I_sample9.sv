module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State definitions with Gray encoding for minimal transitions
localparam [1:0]
    IDLE   = 2'b00,
    GOT1   = 2'b01,
    GOT10  = 2'b11,
    GOT100 = 2'b10;

reg [1:0] current_state, next_state;
reg next_match;

// State register and output registration
always @(posedge CLK) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        MATCH <= next_match;
    end
end

// Optimized next state and output logic
always @(*) begin
    next_match = 1'b0;  // Default output
    case (current_state)
        IDLE:   next_state = IN ? GOT1 : IDLE;
        GOT1:   next_state = IN ? GOT1 : GOT10;
        GOT10:  next_state = IN ? GOT1 : GOT100;
        GOT100: begin
            next_state = IN ? GOT1 : GOT100;
            next_match = IN;  // Only set match when in GOT100 and IN=1
        end
    endcase
end

endmodule