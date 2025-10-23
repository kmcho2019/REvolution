module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// State encodings - ordered by likely frequency of use
localparam D = 2'b11, C = 2'b10, B = 2'b01, A = 2'b00;

// Output is high only in state D (most efficient implementation)
assign out = state[0] & state[1];  // Equivalent to (state == D) but uses bitwise ops

// State transition logic - ordered by likely frequency
always @(*) begin
    case (state) // synthesis parallel_case
        D: next_state = in ? B : C;  // D->B if in=1, else ->C (most active state first)
        C: next_state = in ? D : A;  // C->D if in=1, else ->A
        B: next_state = in ? B : C;  // B->C if in=0, else stay
        A: next_state = in ? B : A;  // A->B if in=1, else stay
    endcase
end

endmodule