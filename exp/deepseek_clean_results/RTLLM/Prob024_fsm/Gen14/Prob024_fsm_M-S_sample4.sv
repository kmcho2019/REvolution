module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// States for sequence detection
parameter IDLE    = 2'b00;
parameter GOT1    = 2'b01;
parameter GOT100  = 2'b10;

reg [1:0] current_state, next_state;

// State transition
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
            MATCH = 1'b0;
            next_state = IN ? GOT1 : IDLE;
        end
        GOT1: begin
            MATCH = 1'b0;
            next_state = IN ? GOT1 : GOT100;
        end
        GOT100: begin
            MATCH = IN;  // Output 1 when completing sequence
            next_state = IN ? GOT1 : IDLE;
        end
        default: begin
            MATCH = 1'b0;
            next_state = IDLE;
        end
    endcase
end

endmodule