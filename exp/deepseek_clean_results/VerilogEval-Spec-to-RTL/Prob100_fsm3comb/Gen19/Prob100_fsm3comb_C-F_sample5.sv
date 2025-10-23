module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// Moore output - depends only on current state
// Output is 1 only in state D (11)
assign out = (state == 2'b11);

// State transition logic
always @(*) begin
    case (state)
        2'b00: next_state = in ? 2'b01 : 2'b00; // State A: A->B if in=1, else stay A
        2'b01: next_state = in ? 2'b01 : 2'b10; // State B: B->B if in=1, else C
        2'b10: next_state = in ? 2'b11 : 2'b00;  // State C: C->D if in=1, else A
        2'b11: next_state = in ? 2'b01 : 2'b10;  // State D: D->B if in=1, else C
    endcase
end

endmodule