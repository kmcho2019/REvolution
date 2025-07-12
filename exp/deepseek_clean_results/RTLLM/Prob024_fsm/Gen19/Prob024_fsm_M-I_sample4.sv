module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State definitions with optimal encoding
localparam [1:0]
    IDLE   = 2'b00,
    GOT1   = 2'b01,
    GOT10  = 2'b10,
    GOT100 = 2'b11;

reg [1:0] current_state, next_state;
reg next_match;
reg IN_prev;

// Clock gating control
wire state_change = (IN != IN_prev);

// State register with clock gating
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
        IN_prev <= 1'b0;
    end else begin
        IN_prev <= IN;
        if (state_change) begin
            current_state <= next_state;
            MATCH <= next_match;
        end
    end
end

// Combined next state and output logic
always @(*) begin
    case (current_state)
        IDLE: begin
            next_state = IN ? GOT1 : IDLE;
            next_match = 1'b0;
        end
        GOT1: begin
            next_state = IN ? GOT1 : GOT10;
            next_match = 1'b0;
        end
        GOT10: begin
            next_state = IN ? GOT1 : GOT100;
            next_match = 1'b0;
        end
        GOT100: begin
            next_state = IN ? GOT1 : GOT10;
            next_match = IN;
        end
    endcase
end

endmodule