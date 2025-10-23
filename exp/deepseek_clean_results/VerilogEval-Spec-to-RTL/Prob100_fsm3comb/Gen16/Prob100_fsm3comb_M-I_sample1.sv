module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// Optimized output logic - only high when both state bits are 1 (state D)
assign out = &state;

// Optimized state transition logic
always @(*) begin
    case (state)
        2'b00: next_state = {1'b0, in};          // A -> A (00) or B (01)
        2'b01: next_state = in ? 2'b01 : 2'b10;  // B -> B or C
        2'b10: next_state = in ? 2'b11 : 2'b00;  // C -> D or A
        2'b11: next_state = in ? 2'b01 : 2'b10;  // D -> B or C (same as B's transition)
    endcase
end

endmodule