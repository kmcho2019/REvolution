module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// Moore output: 1 only in state D (2'b11), 0 otherwise
assign out = (state == 2'b11);

always @(*) begin
    case (state)
        2'b00: next_state = in ? 2'b01 : 2'b00; // State A: A->A (in=0), A->B (in=1)
        2'b01: next_state = in ? 2'b01 : 2'b10; // State B: B->C (in=0), B->B (in=1)
        2'b10: next_state = in ? 2'b11 : 2'b00; // State C: C->A (in=0), C->D (in=1)
        2'b11: next_state = in ? 2'b01 : 2'b10; // State D: D->C (in=0), D->B (in=1)
    endcase
end

endmodule