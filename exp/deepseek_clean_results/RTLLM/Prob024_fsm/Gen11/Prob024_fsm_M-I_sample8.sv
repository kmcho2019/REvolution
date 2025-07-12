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
reg IN_prev;  // To detect input changes

// State and input change tracking
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        IN_prev <= 1'b0;
    end else begin
        current_state <= next_state;
        IN_prev <= IN;
    end
end

// Output registration (separate from state to break critical path)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        MATCH <= 1'b0;
    end else begin
        MATCH <= next_match;
    end
end

// Next state and output logic (only evaluate when input changes)
always @(*) begin
    // Default values
    next_state = current_state;
    next_match = 1'b0;
    
    if (IN != IN_prev || RST) begin  // Only evaluate when input changes
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
                    next_match = 1'b1;  // Output 1 when completing sequence
                    next_state = GOT1;  // Restart detection
                end else begin
                    next_state = GOT10;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end
end

endmodule