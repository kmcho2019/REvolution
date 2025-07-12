module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// Moore output - depends only on current state
assign out = (state == 2'b11); // Output 1 when in state D (2'b11)

// Optimized next state logic with detailed comments
always @(*) begin
    case (state)
        2'b00: next_state = in ? 2'b01 : 2'b00; // A -> B if in=1, else stay A
        2'b01: next_state = in ? 2'b01 : 2'b10; // B -> B if in=1, else C
        2'b10: next_state = in ? 2'b11 : 2'b00; // C -> D if in=1, else A
        2'b11: next_state = in ? 2'b01 : 2'b10; // D -> B if in=1, else C
        default: next_state = 2'b00;            // Fallback to state A
    endcase
end

endmodule