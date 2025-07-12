module TopModule (
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 5'b00001; // reset to 1
    end else begin
        q_reg[4] <= q_reg[0] ^ q_reg[2]; // update MSB with XOR of bits at positions 0 and 2
        q_reg[3:0] <= q_reg[2:0]; // shift bits to the right
    end
end

assign q = q_reg;

endmodule