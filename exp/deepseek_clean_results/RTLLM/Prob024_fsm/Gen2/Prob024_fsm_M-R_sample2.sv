module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State encoding
parameter IDLE      = 3'b000;
parameter S1        = 3'b001;
parameter S10       = 3'b010;
parameter S100      = 3'b011;
parameter S1001     = 3'b100;
parameter MATCH_STATE = 3'b101;

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
        IDLE:      next_state = IN ? S1 : IDLE;
        S1:       next_state = IN ? S1 : S10;
        S10:      next_state = IN ? IDLE : S100;
        S100:     next_state = IN ? S1001 : IDLE;
        S1001:    next_state = IN ? MATCH_STATE : S10;
        MATCH_STATE: next_state = IDLE;
        default:   next_state = IDLE;
    endcase
end

// Mealy output logic
always @(*) begin
    MATCH = (current_state == S1001 && IN) ? 1'b1 : 1'b0;
end

endmodule