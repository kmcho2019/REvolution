module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// States for sequence detection
parameter IDLE    = 2'b00;
parameter GOT1    = 2'b01;
parameter GOT10   = 2'b10;
parameter GOT100  = 2'b11;

reg [1:0] current_state, next_state;
reg next_match;

// State transition and output logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        MATCH <= next_match;
    end
end

// Next state and output logic
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
            next_match = IN;  // Output 1 when completing sequence
        end
        default: begin
            next_state = IDLE;
            next_match = 1'b0;
        end
    endcase
end

endmodule