module LFSR (
    input  wire       clk,
    input  wire       rst,
    output wire [3:0] out
);

    reg [3:0] lfsr_reg;
    wire feedback;

    // Feedback tap is taken from out[0] (LSB shifted out)
    // XOR with taps: taps at bits 3 and 2 per Galois form
    assign feedback = lfsr_reg[0];

    // Output assignment
    assign out = lfsr_reg;

    always @(posedge clk) begin
        if (rst) begin
            lfsr_reg <= 4'b0001;  // Non-zero seed
        end else begin
            // Shift right with conditional feedback application
            // Bit 3 gets lfsr_reg[2] XOR feedback if tap active
            lfsr_reg[3] <= lfsr_reg[2] ^ feedback;
            // Bit 2 gets lfsr_reg[1] XOR feedback if tap active
            lfsr_reg[2] <= lfsr_reg[1] ^ feedback;
            // Bit 1 gets lfsr_reg[0]
            lfsr_reg[1] <= lfsr_reg[0];
            // Bit 0 gets feedback (shift-in)
            lfsr_reg[0] <= feedback;
        end
    end

endmodule