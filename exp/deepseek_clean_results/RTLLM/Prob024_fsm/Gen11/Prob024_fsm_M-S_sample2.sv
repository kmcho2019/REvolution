module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// Binary encoded states (2 bits for 3 states)
parameter IDLE  = 2'b00;
parameter GOT1  = 2'b01;
parameter GOT10 = 2'b10;

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
            MATCH = 1'b0;
        end
        GOT1: begin
            next_state = IN ? GOT1 : GOT10;
            MATCH = 1'b0;
        end
        GOT10: begin
            if (IN) begin
                next_state = GOT1;
                // Check if we've seen 1001 pattern before this 1
                MATCH = (current_state == GOT10) && IN;
            end else begin
                next_state = IDLE;  // Sequence broken
                MATCH = 1'b0;
            end
        end
        default: begin
            next_state = IDLE;
            MATCH = 1'b0;
        end
    endcase
end

endmodule