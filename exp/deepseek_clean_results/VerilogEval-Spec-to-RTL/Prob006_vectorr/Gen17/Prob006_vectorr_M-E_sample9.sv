module TopModule (
    input clk,            // Clock input
    input reset,          // Active-high reset
    input [7:0] in,       // 8-bit input
    input load,           // Load signal to start reversal
    output [7:0] out,     // 8-bit reversed output
    output ready          // Output valid indicator
);

    reg [7:0] shift_reg;  // Shift register for reversal
    reg [2:0] count;      // Bit counter (0-7)
    reg ready_reg;        // Ready status register

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 8'b0;
            count <= 3'b0;
            ready_reg <= 1'b0;
        end
        else if (load) begin
            // Initialize on load
            shift_reg <= {in[0], 7'b0};  // Load LSB first
            count <= 3'b1;               // Start counting
            ready_reg <= 1'b0;
        end
        else if (!ready_reg && count < 3'd7) begin
            // Shift in next bit
            shift_reg <= {in[count], shift_reg[7:1]};
            count <= count + 1;
        end
        else if (count == 3'd7) begin
            // Final bit loaded
            ready_reg <= 1'b1;
        end
    end

    assign out = shift_reg;
    assign ready = ready_reg;

    /* Operation sequence:
     * Cycle 0: load=1 -> shift_reg = {in[0], 0000000}, count=1
     * Cycle 1: shift_reg = {in[1], in[0], 000000}, count=2
     * ...
     * Cycle 7: shift_reg = {in[7], in[6], ..., in[0]}, ready=1
     */

endmodule