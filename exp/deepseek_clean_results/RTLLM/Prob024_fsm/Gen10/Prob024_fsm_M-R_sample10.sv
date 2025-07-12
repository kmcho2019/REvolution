module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// Explicit binary state encoding
parameter [1:0] IDLE    = 2'b00;
parameter [1:0] GOT1    = 2'b01;
parameter [1:0] GOT10   = 2'b10;
parameter [1:0] GOT100  = 2'b11;

reg [1:0] current_state, next_state;

// Sequential state transition with synchronous reset
always @(posedge CLK) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Combinational next state and output logic
always @(*) begin
    // Default assignments
    next_state = current_state;
    MATCH = 1'b0;
    
    if (RST) begin
        next_state = IDLE;
        MATCH = 1'b0;
    end else begin
        case (current_state)
            IDLE: begin
                next_state = IN ? GOT1 : IDLE;
            end
            GOT1: begin
                next_state = IN ? GOT1 : GOT10;
            end
            GOT10: begin
                next_state = IN ? GOT1 : GOT100;
            end
            GOT100: begin
                if (IN) begin
                    next_state = GOT1;
                    MATCH = 1'b1;  // Mealy output on transition
                end else begin
                    next_state = IDLE;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end
end

endmodule