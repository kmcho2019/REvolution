module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// New Gray code state encoding: 
// A=00, B=01, C=11, D=10
// Output depends only on MSB (state[1]) in this encoding
assign out = state[1]; // Output 1 when in states C (11) or D (10)

always @(*) begin
    case (state)
        2'b00: next_state = in ? 2'b01 : 2'b00; // A: A->B if in=1, else stay A
        2'b01: next_state = in ? 2'b01 : 2'b11; // B: B->B if in=1, else C
        2'b11: next_state = in ? 2'b10 : 2'b00; // C: C->D if in=1, else A
        2'b10: next_state = in ? 2'b01 : 2'b11; // D: D->B if in=1, else C
    endcase
end

endmodule