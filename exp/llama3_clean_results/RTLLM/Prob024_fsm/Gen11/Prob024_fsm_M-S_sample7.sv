module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [4:0] state; // One-hot encoding for states
reg [4:0] next_state; // Next state

// Sequential logic for state update
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= 5'b10000; // Reset to S0
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state
always @(*) begin
    case(state)
        5'b10000: next_state = IN ? 5'b01000 : 5'b10000; // S0
        5'b01000: next_state = ~IN ? 5'b00100 : 5'b10000; // S1
        5'b00100: next_state = ~IN ? 5'b00010 : 5'b10000; // S2
        5'b00010: next_state = IN ? 5'b00001 : 5'b10000; // S3
        5'b00001: next_state = IN ? 5'b00001 : 5'b10000; // S4
        default: next_state = 5'b10000; // S0
    endcase
end

// Combinational logic for output
always @(*) begin
    case(state)
        5'b00001: MATCH = IN ? 1'b1 : 1'b0; // Set MATCH to 1 when sequence is 10011
        default: MATCH = 1'b0;
    endcase
end

endmodule