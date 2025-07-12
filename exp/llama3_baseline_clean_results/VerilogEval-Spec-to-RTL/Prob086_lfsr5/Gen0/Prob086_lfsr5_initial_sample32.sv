module TopModule(
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] q_reg; // 5-bit register to store the LFSR state

// Initialize the LFSR with the value 1 (00001) when reset is high
always @(posedge clk or posedge reset) begin
    if (reset) begin
        q_reg <= 5'b00001;
    end else begin
        // Shift the LFSR right and XOR the taps with the LSB
        q_reg[4] <= q_reg[3]; // Shift bit 3 to bit 4
        q_reg[3] <= q_reg[2] ^ q_reg[0]; // Tap at bit 3
        q_reg[2] <= q_reg[1];
        q_reg[1] <= q_reg[0];
        q_reg[0] <= q_reg[4] ^ q_reg[3]; // Tap at bit 5 (using bit 4)
    end
end

// Assign the LFSR state to the output
assign q = q_reg;

endmodule