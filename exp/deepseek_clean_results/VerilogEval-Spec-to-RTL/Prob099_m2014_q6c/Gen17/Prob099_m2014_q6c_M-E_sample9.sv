module TopModule (
    input [5:0] y,  // Current state in one-hot encoding (A-F)
    input w,       // Input signal
    output Y1,     // Next state y[0] (A)
    output Y3      // Next state y[2] (C)
);

    reg [5:0] next_state;

    // State transition lookup table
    always @(*) begin
        case ({y, w})
            // State A transitions
            7'b000001_0: next_state = 6'b000010; // A->B
            7'b000001_1: next_state = 6'b000001; // A->A
            
            // State B transitions
            7'b000010_0: next_state = 6'b000100; // B->C
            7'b000010_1: next_state = 6'b001000; // B->D
            
            // State C transitions
            7'b000100_0: next_state = 6'b010000; // C->E
            7'b000100_1: next_state = 6'b001000; // C->D
            
            // State D transitions
            7'b001000_0: next_state = 6'b100000; // D->F
            7'b001000_1: next_state = 6'b000001; // D->A
            
            // State E transitions
            7'b010000_0: next_state = 6'b010000; // E->E
            7'b010000_1: next_state = 6'b001000; // E->D
            
            // State F transitions
            7'b100000_0: next_state = 6'b000100; // F->C
            7'b100000_1: next_state = 6'b001000; // F->D
            
            default: next_state = 6'b000001; // Default to state A
        endcase
    end

    // Extract required next-state bits
    assign Y1 = next_state[0]; // Next state A (y[0])
    assign Y3 = next_state[2]; // Next state C (y[2])

endmodule