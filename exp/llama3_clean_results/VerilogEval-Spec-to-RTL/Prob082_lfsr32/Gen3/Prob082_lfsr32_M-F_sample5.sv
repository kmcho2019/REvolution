module TopModule(
    input  clk,
    input  reset,
    output [31:0] q
);

reg [31:0] q_reg;
reg [31:0] q_next;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 32'h1;
    end else begin
        q_reg <= q_next;
    end
end

assign q = q_reg;

// Calculate the next state by shifting right and applying XOR for taps
assign q_next = {
    q_reg[21] ^ q_reg[1] ^ q_reg[0],  // MSB (bit 31)
    q_reg[30:22],                    // Bits 30 to 22
    q_reg[21] ^ q_reg[0],            // Bit 21 with XOR
    q_reg[20:2],                     // Bits 20 to 2
    q_reg[1] ^ q_reg[0],             // Bit 1 with XOR
    q_reg[0]                         // LSB (bit 0)
};

endmodule