module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// States for sequence detection
parameter IDLE    = 2'b00;
parameter GOT1    = 2'b01;
parameter GOT100  = 2'b10;

reg [1:0] current_state, next_state;

// State transition logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state and output logic
always @(*) begin
    case (current_state)
        IDLE: begin
            next_state = IN ? GOT1 : IDLE;
        end
        GOT1: begin
            next_state = IN ? GOT1 : GOT100;
        end
        GOT100: begin
            next_state = IN ? (current_state == GOT100 ? GOT1 : IDLE) : GOT100;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Mealy output - depends on current state and input
assign MATCH = (current_state == GOT100) && IN;

endmodule