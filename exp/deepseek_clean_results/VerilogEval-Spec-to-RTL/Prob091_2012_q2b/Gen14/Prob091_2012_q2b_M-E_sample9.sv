module TopModule (
    input [5:0] y,  // One-hot encoded state
    input w,        // State machine input
    output Y1,      // Next state for y[1]
    output Y3       // Next state for y[3]
);

    // Combined address for ROM lookup
    wire [6:0] rom_addr = {y, w};
    reg [5:0] next_state;

    // ROM implementation using case statement
    always @(*) begin
        casez (rom_addr)
            // Format: {y[5:0], w} : next_state
            7'b000001_1: next_state = 6'b000010; // A->B
            7'b000001_0: next_state = 6'b000001; // A->A
            7'b000010_1: next_state = 6'b000100; // B->C
            7'b000010_0: next_state = 6'b001000; // B->D
            7'b000100_1: next_state = 6'b010000; // C->E
            7'b000100_0: next_state = 6'b001000; // C->D
            7'b001000_1: next_state = 6'b100000; // D->F
            7'b001000_0: next_state = 6'b000001; // D->A
            7'b010000_1: next_state = 6'b010000; // E->E
            7'b010000_0: next_state = 6'b001000; // E->D
            7'b100000_1: next_state = 6'b000100; // F->C
            7'b100000_0: next_state = 6'b001000; // F->D
            default:     next_state = 6'b000001; // Default to state A
        endcase
    end

    // Extract Y1 and Y3 from next_state
    assign Y1 = next_state[1];
    assign Y3 = next_state[3];

    /* ROM Contents Visualization:
       Current | Input | Next
       --------+-------+------
       A (000001) | 1 | B (000010)
       A (000001) | 0 | A (000001)
       B (000010) | 1 | C (000100)
       B (000010) | 0 | D (001000)
       C (000100) | 1 | E (010000)
       C (000100) | 0 | D (001000)
       D (001000) | 1 | F (100000)
       D (001000) | 0 | A (000001)
       E (010000) | 1 | E (010000)
       E (010000) | 0 | D (001000)
       F (100000) | 1 | C (000100)
       F (100000) | 0 | D (001000)
    */
endmodule