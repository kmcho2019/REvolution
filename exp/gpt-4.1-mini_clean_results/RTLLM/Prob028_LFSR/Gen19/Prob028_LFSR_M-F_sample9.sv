module LFSR (
    input  wire       clk,
    input  wire       rst,
    output wire [3:0] out
);

    reg [3:0] lfsr_reg;
    wire feedback;

    // Feedback is inverted XOR of bits 3 and 2 of the register
    assign feedback = ~(lfsr_reg[3] ^ lfsr_reg[2]);
    assign out = lfsr_reg;

    always @(posedge clk) begin
        if (rst)
            lfsr_reg <= 4'b0001;  // Initialize to non-zero seed to avoid lock-up
        else
            lfsr_reg <= {lfsr_reg[2:0], feedback};  // Shift left, insert feedback at LSB
    end

endmodule