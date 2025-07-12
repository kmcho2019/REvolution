module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Shift register states (one-hot style but with shift transitions)
    // Order: A, B, C, D, E, F
    reg [5:0] state_shift;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 6'b000001; // Start at state A
        end else begin
            case (1'b1) // Find which state bit is set
                state_shift[0]: state_shift <= w ? 6'b000001 : 6'b000010; // A->A or A->B
                state_shift[1]: state_shift <= w ? 6'b001000 : 6'b000100; // B->D or B->C
                state_shift[2]: state_shift <= w ? 6'b001000 : 6'b010000; // C->D or C->E
                state_shift[3]: state_shift <= w ? 6'b000001 : 6'b100000; // D->A or D->F
                state_shift[4]: state_shift <= w ? 6'b001000 : 6'b010000; // E->D or E->E
                state_shift[5]: state_shift <= w ? 6'b001000 : 6'b000100; // F->D or F->C
                default: state_shift <= 6'b000001; // Fallback to A
            endcase
        end
    end

    // Output is 1 for states E (bit4) or F (bit5)
    assign z = state_shift[4] | state_shift[5];

endmodule