module TopModule (
    input clk,          // Clock input
    input reset,        // Active-high reset
    input [7:0] in,     // 8-bit input
    input load,         // Load signal to start reversal
    output [7:0] out,   // 8-bit reversed output
    output valid        // Output valid signal
);

    reg [7:0] shift_reg;    // Shift register for reversal
    reg [2:0] counter;      // 3-bit counter (0-7)
    reg valid_reg;          // Valid signal register

    // State machine for bit reversal
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 8'b0;
            counter <= 3'b0;
            valid_reg <= 1'b0;
        end else begin
            if (load) begin
                // Initialize on load
                shift_reg <= 8'b0;
                counter <= 3'b0;
                valid_reg <= 1'b0;
            end else if (counter < 3'd7) begin
                // Shift in bits in reverse order
                shift_reg <= {shift_reg[6:0], in[counter]};
                counter <= counter + 1;
                valid_reg <= 1'b0;
            end else begin
                // Final bit and set valid
                shift_reg <= {shift_reg[6:0], in[counter]};
                valid_reg <= 1'b1;
            end
        end
    end

    assign out = shift_reg;
    assign valid = valid_reg;

    /* Operation sequence:
     * 1. Assert load to start reversal
     * 2. On each clock cycle, one bit is shifted in reverse order
     * 3. After 8 cycles, valid goes high with reversed output
     * 4. Bits are loaded as:
     *    cycle 0: in[0] -> out[7]
     *    cycle 1: in[1] -> out[6]
     *    ...
     *    cycle 7: in[7] -> out[0]
     */

endmodule