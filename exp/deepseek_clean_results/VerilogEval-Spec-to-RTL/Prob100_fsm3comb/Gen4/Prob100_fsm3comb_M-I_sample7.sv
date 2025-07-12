module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

always @(*) begin
    out = &state; // Output is 1 only when both state bits are 1 (state D)
    
    // synthesis parallel_case
    case (state)
        2'b00: next_state = {1'b0, in};       // A -> A (00) or B (01)
        2'b01: next_state = in ? 2'b01 : 2'b10; // B -> B or C
        2'b10: next_state = in ? 2'b11 : 2'b00; // C -> D or A
        2'b11: next_state = {~in, in};        // D -> C (10) or B (01)
    endcase
end

endmodule