module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Shift register states (one-active encoding)
    // Bit positions: [F E D C B A]
    reg [5:0] state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 6'b000001; // Reset to state A (LSB)
        end else begin
            case (1'b1) // Synthesis will optimize this to parallel checks
                state[0]: state <= w ? 6'b000010 : 6'b000001; // A transitions
                state[1]: state <= w ? 6'b000100 : 6'b001000; // B transitions
                state[2]: state <= w ? 6'b010000 : 6'b001000; // C transitions
                state[3]: state <= w ? 6'b100000 : 6'b000001; // D transitions
                state[4]: state <= w ? 6'b010000 : 6'b001000; // E transitions
                state[5]: state <= w ? 6'b000100 : 6'b001000; // F transitions
                default: state <= 6'b000001;
            endcase
        end
    end

    // Output logic - E or F states (bits 4 and 5)
    assign z = state[4] | state[5];

endmodule