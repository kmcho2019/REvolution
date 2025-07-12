module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// Define states
parameter IDLE   = 3'b000;
parameter S1     = 3'b001;
parameter S10    = 3'b010;
parameter S100   = 3'b011;
parameter S1001  = 3'b100;
parameter S10011 = 3'b101;

reg [2:0] current_state, next_state;

// State transition logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: begin
            next_state = IN ? S1 : IDLE;
        end
        S1: begin
            next_state = IN ? S1 : S10;
        end
        S10: begin
            next_state = IN ? S1 : S100;
        end
        S100: begin
            next_state = IN ? S1001 : IDLE;
        end
        S1001: begin
            next_state = IN ? S10011 : S10;
        end
        S10011: begin
            next_state = IN ? S1 : S10;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Output logic (Mealy style)
always @(*) begin
    case (current_state)
        S1001: begin
            MATCH = (IN) ? 1'b1 : 1'b0;  // Only match when last bit is 1
        end
        default: begin
            MATCH = 1'b0;
        end
    endcase
end

endmodule