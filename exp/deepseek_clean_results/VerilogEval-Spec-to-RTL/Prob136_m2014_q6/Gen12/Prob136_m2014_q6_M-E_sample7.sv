module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // 6-bit shift register where each bit represents a state (A-F)
    reg [5:0] state_shift = 6'b000001;  // A is LSB, F is MSB

    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 6'b000001;  // Reset to state A
        end else begin
            case (state_shift)
                // State A (000001)
                6'b000001: state_shift <= w ? 6'b000001 : 6'b000010;
                // State B (000010)
                6'b000010: state_shift <= w ? 6'b000100 : 6'b000100;
                // State C (000100)
                6'b000100: state_shift <= w ? 6'b000100 : 6'b001000;
                // State D (001000)
                6'b001000: state_shift <= w ? 6'b000001 : 6'b010000;
                // State E (010000)
                6'b010000: state_shift <= w ? 6'b000100 : 6'b010000;
                // State F (100000)
                6'b100000: state_shift <= w ? 6'b000100 : 6'b000100;
                default: state_shift <= 6'b000001;
            endcase
        end
    end

    // Output is high for states E (010000) and F (100000)
    assign z = state_shift[4] | state_shift[5];

endmodule