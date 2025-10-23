module TopModule (
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 5'b10000; // reset to 1 (assuming the MSB is the most significant bit)
    end else begin
        q_reg[4] <= q_reg[0] ^ q_reg[2]; // update MSB with XOR of bits at positions 0 and 2
        q_reg[3] <= q_reg[4]; // shift MSB to position 3
        q_reg[2] <= q_reg[3]; // shift bit at position 3 to position 2
        q_reg[1] <= q_reg[2]; // shift bit at position 2 to position 1
        q_reg[0] <= q_reg[1]; // shift bit at position 1 to position 0
    end
end

assign q = q_reg;

endmodule