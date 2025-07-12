module TopModule(
    input [5:0] y,    // Current state (one-hot encoded)
    input w,          // Input
    output Y1, Y3     // Next state bits y[1] and y[3]
);

    reg [5:0] next_state;

    always @(*) begin
        case (1'b1)  // Synthesis will optimize this to parallel case
            y[0]: next_state = w ? 6'b000001 : 6'b000010;  // A -> A or B
            y[1]: next_state = w ? 6'b001000 : 6'b000100;  // B -> D or C
            y[2]: next_state = w ? 6'b001000 : 6'b010000;  // C -> D or E
            y[3]: next_state = w ? 6'b000001 : 6'b100000;  // D -> A or F
            y[4]: next_state = w ? 6'b001000 : 6'b010000;  // E -> D or E
            y[5]: next_state = w ? 6'b001000 : 6'b000100;  // F -> D or C
            default: next_state = 6'b000001;  // Default to state A
        endcase
    end

    assign Y1 = next_state[1];  // y[1] is state B
    assign Y3 = next_state[3];  // y[3] is state D

endmodule