module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// Define states with one-hot encoding for better timing
parameter IDLE  = 3'b000;
parameter S1    = 3'b001;
parameter S10   = 3'b010;
parameter S100  = 3'b011;
parameter S1001 = 3'b100;

reg [2:0] current_state, next_state;

// State transition logic (synchronous)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic (combinational)
always @(*) begin
    case (current_state)
        IDLE: next_state = IN ? S1 : IDLE;
        S1:   next_state = IN ? S1 : S10;
        S10:  next_state = IN ? S1 : S100;
        S100: next_state = IN ? S1001 : IDLE;
        S1001: next_state = IN ? S1 : S10;
        default: next_state = IDLE;
    endcase
end

// Output logic (Mealy - combinatorial)
always @(*) begin
    if (RST) begin
        MATCH = 1'b0;
    end else begin
        MATCH = (current_state == S1001) && IN;
    end
end

endmodule