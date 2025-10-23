module fsm (
    input wire CLK,
    input wire RST,
    input wire IN,
    output reg MATCH
);

// State encoding with descriptive names
localparam [1:0]
    IDLE   = 2'b00,
    GOT1   = 2'b01,
    GOT10  = 2'b10,
    GOT100 = 2'b11;

reg [1:0] current_state, next_state;

// State transition and output logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end
    else begin
        current_state <= next_state;
        // Mealy output registered for better timing
        case (current_state)
            GOT100: MATCH <= IN;  // Output 1 when we get the final '1' in sequence
            default: MATCH <= 1'b0;
        endcase
    end
end

// Next state logic (combinational)
always @(*) begin
    case (current_state)
        IDLE:   next_state = IN ? GOT1 : IDLE;
        GOT1:   next_state = IN ? GOT1 : GOT10;
        GOT10:  next_state = IN ? IDLE : GOT100;
        GOT100: next_state = IN ? GOT1 : IDLE;
        default: next_state = IDLE;
    endcase
end

endmodule