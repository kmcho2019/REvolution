module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// Continuous assignment for output (only 1 in state D)
assign out = (state == 2'b11);

always @(*) begin
    // synthesis parallel_case
    case (state)
        2'b00: next_state = in ? 2'b01 : 2'b00; // A -> B or A
        2'b01: next_state = in ? 2'b01 : 2'b10; // B -> B or C
        2'b10: next_state = in ? 2'b11 : 2'b00; // C -> D or A
        2'b11: next_state = in ? 2'b01 : 2'b10; // D -> B or C
        default: next_state = 2'b00; // Fallback to state A
    endcase
end

endmodule