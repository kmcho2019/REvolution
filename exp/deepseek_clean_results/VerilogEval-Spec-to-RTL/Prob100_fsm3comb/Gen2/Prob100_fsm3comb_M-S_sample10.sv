module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

always @(*) begin
    case (state)
        2'b00: next_state = in ? 2'b01 : 2'b00; // A -> B if in=1, else A
        2'b01: next_state = in ? 2'b01 : 2'b10; // B -> B if in=1, else C
        2'b10: next_state = in ? 2'b11 : 2'b00; // C -> D if in=1, else A
        2'b11: next_state = in ? 2'b01 : 2'b10; // D -> B if in=1, else C
    endcase
    
    out = (state == 2'b11); // Output 1 only in state D
end

endmodule