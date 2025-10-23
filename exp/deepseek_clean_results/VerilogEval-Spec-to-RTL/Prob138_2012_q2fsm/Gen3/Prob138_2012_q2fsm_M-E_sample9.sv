module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Shift register implementation (6-bit circular)
    reg [5:0] state_shift = 6'b000001;  // Initial state A (LSB)
    wire [5:0] next_shift;

    // Shift direction depends on 'w' and current state
    assign next_shift = 
        (state_shift == 6'b000001) ? (w ? 6'b000010 : 6'b000001) : // A
        (state_shift == 6'b000010) ? (w ? 6'b000100 : 6'b001000) : // B
        (state_shift == 6'b000100) ? (w ? 6'b010000 : 6'b001000) : // C
        (state_shift == 6'b001000) ? (w ? 6'b100000 : 6'b000001) : // D
        (state_shift == 6'b010000) ? (w ? 6'b010000 : 6'b001000) : // E
        (state_shift == 6'b100000) ? (w ? 6'b000100 : 6'b001000) : // F
        6'b000001;  // Default to A

    // State register update
    always @(posedge clk) begin
        if (reset)
            state_shift <= 6'b000001;  // Reset to state A
        else
            state_shift <= next_shift;
    end

    // Output logic - z is 1 for states E (010000) and F (100000)
    assign z = state_shift[4] | state_shift[5];

endmodule