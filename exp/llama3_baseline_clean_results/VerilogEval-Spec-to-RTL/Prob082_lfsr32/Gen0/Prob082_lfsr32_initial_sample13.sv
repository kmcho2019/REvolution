module TopModule(
    input  clk,
    input  reset,
    output [31:0] q
);

reg [31:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 32'h1;
    end else begin
        q_reg[31] <= q_reg[30]; // Shift right
        q_reg[30:23] <= q_reg[29:22]; // Shift right
        q_reg[22] <= q_reg[21] ^ q_reg[0]; // Tap at position 22
        q_reg[21:2] <= q_reg[20:1]; // Shift right
        q_reg[1] <= q_reg[0] ^ q_reg[0]; // Tap at position 1
        q_reg[0] <= q_reg[31] ^ q_reg[22] ^ q_reg[2] ^ q_reg[1]; // Tap at position 32, also considering taps at 2 and 1 for LFSR feedback
    end
end

assign q = q_reg;

endmodule