module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// State encoding (3 bits)
parameter IDLE   = 3'b000;
parameter S1     = 3'b001;
parameter S10    = 3'b010;
parameter S100   = 3'b011;
parameter S1001  = 3'b100;

reg [2:0] current_state, next_state;

// State transition
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state and output logic (combinational)
always @(*) begin
    case (current_state)
        IDLE:   next_state = IN ? S1 : IDLE;
        S1:     next_state = IN ? S1 : S10;
        S10:    next_state = IN ? S1 : S100;
        S100:   next_state = IN ? S1001 : IDLE;
        S1001:  next_state = IN ? S1 : S10; // On match, restart or partial overlap
        default: next_state = IDLE;
    endcase
end

// Mealy output - depends on current state AND input
assign MATCH = (current_state == S1001 && IN == 1'b1);

endmodule