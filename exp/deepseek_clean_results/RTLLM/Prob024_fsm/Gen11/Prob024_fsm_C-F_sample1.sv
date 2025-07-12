module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// States for sequence detection
parameter IDLE   = 3'b000;
parameter S1     = 3'b001;
parameter S10    = 3'b010;
parameter S100   = 3'b011;
parameter S1001  = 3'b100;

reg [2:0] current_state, next_state;
reg next_match;

// Combined state register and output update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        MATCH <= next_match;
    end
end

// Combined next state and output logic
always @(*) begin
    case (current_state)
        IDLE: begin
            next_state = IN ? S1 : IDLE;
            next_match = 1'b0;
        end
        S1: begin
            next_state = IN ? S1 : S10;
            next_match = 1'b0;
        end
        S10: begin
            next_state = IN ? IDLE : S100;
            next_match = 1'b0;
        end
        S100: begin
            next_state = IN ? S1001 : IDLE;
            next_match = 1'b0;
        end
        S1001: begin
            next_state = IN ? S1 : IDLE;
            next_match = IN;  // Mealy output when completing sequence
        end
        default: begin
            next_state = IDLE;
            next_match = 1'b0;
        end
    endcase
end

endmodule