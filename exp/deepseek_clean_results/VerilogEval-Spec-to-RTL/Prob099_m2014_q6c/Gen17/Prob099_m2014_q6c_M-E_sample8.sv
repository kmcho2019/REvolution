module TopModule (
    input [5:0] y,  // Current state in one-hot: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input w,        // Input signal
    output Y1,      // Next state y[1] (state B)
    output Y3       // Next state y[3] (state D)
);

    reg [5:0] next_state;

    // Next state logic using casez for one-hot decoding
    always @(*) begin
        casez (y)
            6'b000001: next_state = w ? 6'b000001 : 6'b000010; // A -> A (w=1) or B (w=0)
            6'b000010: next_state = w ? 6'b001000 : 6'b000100; // B -> D (w=1) or C (w=0)
            6'b000100: next_state = w ? 6'b001000 : 6'b010000; // C -> D (w=1) or E (w=0)
            6'b001000: next_state = w ? 6'b000001 : 6'b100000; // D -> A (w=1) or F (w=0)
            6'b010000: next_state = w ? 6'b001000 : 6'b010000; // E -> D (w=1) or E (w=0)
            6'b100000: next_state = w ? 6'b001000 : 6'b000100; // F -> D (w=1) or C (w=0)
            default:   next_state = 6'b000001;                 // Default to state A
        endcase
    end

    // Extract required bits from next state
    assign Y1 = next_state[1];
    assign Y3 = next_state[3];

endmodule