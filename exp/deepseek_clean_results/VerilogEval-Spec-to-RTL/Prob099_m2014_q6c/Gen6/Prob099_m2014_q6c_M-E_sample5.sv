module TopModule (
    input [5:0] y,  // Current state in one-hot encoding (A-F)
    input w,       // Input signal
    output Y1,     // Next state y[0] (A)
    output Y3      // Next state y[2] (C)
);

    // Internal next state signals
    reg [5:0] next_state;

    always @(*) begin
        case (1'b1)
            y[0]: next_state = w ? 6'b000001 : 6'b000010; // A -> A or B
            y[1]: next_state = w ? 6'b001000 : 6'b000100; // B -> D or C
            y[2]: next_state = w ? 6'b001000 : 6'b010000; // C -> D or E
            y[3]: next_state = w ? 6'b000001 : 6'b100000; // D -> A or F
            y[4]: next_state = w ? 6'b001000 : 6'b010000; // E -> D or E
            y[5]: next_state = w ? 6'b001000 : 6'b000100; // F -> D or C
            default: next_state = 6'b000001; // Default to A
        endcase
    end

    // Output assignments
    assign Y1 = next_state[0];  // Next state is A
    assign Y3 = next_state[2];  // Next state is C

endmodule