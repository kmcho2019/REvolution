module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State encoding with descriptive names
parameter IDLE   = 3'b000;
parameter S1     = 3'b001;
parameter S10    = 3'b010;
parameter S100   = 3'b011;
parameter S1001  = 3'b100;
parameter S10011 = 3'b101;

reg [2:0] current_state, next_state;

// State register (sequential)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Optimized next state logic (combinational)
always @(*) begin
    case (current_state)
        IDLE:   next_state = IN ? S1 : IDLE;
        S1:     next_state = IN ? S1 : S10;
        S10:    next_state = IN ? S1 : S100;
        S100:   next_state = IN ? S1001 : IDLE;
        S1001:  next_state = IN ? S10011 : S10;
        S10011: next_state = IN ? S1 : S10;
        default: next_state = IDLE;
    endcase
end

// Simplified output logic (Mealy style)
always @(*) begin
    MATCH = (current_state == S1001) && IN;
end

endmodule