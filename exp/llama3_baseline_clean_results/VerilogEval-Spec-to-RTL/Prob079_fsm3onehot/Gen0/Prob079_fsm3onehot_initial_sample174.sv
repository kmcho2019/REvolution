module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Derive next_state based on current state and input
always @(*) begin
    case(state)
        4'b0001: next_state = in ? 4'b0010 : 4'b0001; // From A
        4'b0010: next_state = in ? 4'b0010 : 4'b0100; // From B
        4'b0100: next_state = in ? 4'b1000 : 4'b0001; // From C
        4'b1000: next_state = in ? 4'b0010 : 4'b0100; // From D
        default: next_state = 4'bxxxx; // Handle undefined states
    endcase
end

// Derive out based on current state
always @(*) begin
    case(state)
        4'b0001, 4'b0010, 4'b0100: out = 1'b0; // A, B, C
        4'b1000: out = 1'b1; // D
        default: out = 1'bx; // Handle undefined states
    endcase
end

endmodule