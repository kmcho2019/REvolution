module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Define the one-hot state encodings
`define A 4'b0001
`define B 4'b0010
`define C 4'b0100
`define D 4'b1000

// Next state logic
always @(*) begin
    case (state)
        `A: next_state = in ? `B : `A;
        `B: next_state = in ? `B : `C;
        `C: next_state = in ? `D : `A;
        `D: next_state = in ? `B : `C;
        default: next_state = 4'bxxxx; // Handle unknown states
    endcase
end

// Output logic
always @(*) begin
    case (state)
        `A, `B, `C: out = 0;
        `D: out = 1;
        default: out = 1'bx; // Handle unknown states
    endcase
end

endmodule