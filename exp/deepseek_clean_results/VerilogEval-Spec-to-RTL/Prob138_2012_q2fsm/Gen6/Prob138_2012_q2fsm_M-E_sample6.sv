module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Shift register states (circular)
    // Position mapping:
    // [5] = A (0)
    // [4] = B (0)
    // [3] = C (0)
    // [2] = D (0)
    // [1] = E (1)
    // [0] = F (1)
    reg [5:0] state_shift;

    // Shift register control
    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 6'b000001; // Start at state A (bit 5)
        end else begin
            case (1'b1) // Synthesis will optimize this case statement
                state_shift[5]: // State A
                    state_shift <= w ? 6'b000010 : 6'b000001;
                state_shift[4]: // State B
                    state_shift <= w ? 6'b000100 : 6'b001000;
                state_shift[3]: // State C
                    state_shift <= w ? 6'b010000 : 6'b001000;
                state_shift[2]: // State D
                    state_shift <= w ? 6'b100000 : 6'b000001;
                state_shift[1]: // State E
                    state_shift <= w ? 6'b010000 : 6'b001000;
                state_shift[0]: // State F
                    state_shift <= w ? 6'b000100 : 6'b001000;
                default:
                    state_shift <= 6'b000001;
            endcase
        end
    end

    // Output is 1 when in states E or F (positions 1 or 0)
    assign z = state_shift[1] | state_shift[0];

endmodule