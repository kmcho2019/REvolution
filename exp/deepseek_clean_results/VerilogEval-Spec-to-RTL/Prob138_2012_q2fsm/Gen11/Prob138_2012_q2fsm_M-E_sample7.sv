module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Shift register states (one-hot-like with shifting behavior)
    // A: 001, B: 010, C: 100, D: 001 (wrapped), E: 100, F: 010
    reg [2:0] state_reg;

    // State transition logic through shifting
    always @(posedge clk) begin
        if (reset) begin
            state_reg <= 3'b001;  // Reset to state A (001)
        end else begin
            case (state_reg)
                3'b001: state_reg <= w ? 3'b010 : 3'b001;  // A -> B or A
                3'b010: state_reg <= w ? 3'b100 : 3'b001;  // B -> C or D (001)
                3'b100: state_reg <= w ? 3'b100 : 3'b001;  // C -> E (100) or D (001)
                default: state_reg <= 3'b001;  // Default to A
            endcase
            
            // Special handling for states E and F which reuse patterns
            if (state_reg == 3'b100 && !w) state_reg <= 3'b001;  // E -> D
            if (state_reg == 3'b010 && w) state_reg <= 3'b100;   // F -> C
        end
    end

    // Output logic - z is 1 when in states E (100) or F (010 with special condition)
    assign z = (state_reg == 3'b100) || 
               (state_reg == 3'b010 && $past(state_reg) == 3'b100);

endmodule