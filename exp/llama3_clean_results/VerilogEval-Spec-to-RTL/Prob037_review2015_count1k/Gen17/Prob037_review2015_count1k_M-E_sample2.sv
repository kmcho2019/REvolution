module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] lfsr_reg;

always @(posedge clk) begin
    if (reset) begin
        lfsr_reg <= 10'd1; // initialize with a non-zero value
    end else begin
        lfsr_reg <= {lfsr_reg[8:0], lfsr_reg[9] ^ (lfsr_reg[0] & lfsr_reg[3])}; // x^10 + x^3 + 1
    end
end

assign q = lfsr_reg - 1; // subtract 1 to make the sequence start from 0

endmodule