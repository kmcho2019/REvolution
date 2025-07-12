module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    // Shift register stages: prev and curr inputs stored per bit
    reg [31:0] shift_reg_0;  // oldest input state (2 cycles ago)
    reg [31:0] shift_reg_1;  // most recent input state (previous cycle)

    always @(posedge clk) begin
        if (reset) begin
            shift_reg_0 <= 32'b0;
            shift_reg_1 <= 32'b0;
            out <= 32'b0;
        end else begin
            // Shift in current input into stage 1, move stage 1 into stage 0
            shift_reg_0 <= shift_reg_1;
            shift_reg_1 <= in;

            // Detect falling edge: if prev input=1 and curr input=0 at the previous cycle transition
            // That is, compare shift_reg_0 and shift_reg_1 at previous cycle boundary.
            // Actually, falling edge occurs between shift_reg_0 and shift_reg_1:
            // The transition is from shift_reg_0=1 to shift_reg_1=0, detected now.

            // Once detected, latch bit in out until reset
            out <= out | (shift_reg_0 & ~shift_reg_1);
        end
    end

endmodule