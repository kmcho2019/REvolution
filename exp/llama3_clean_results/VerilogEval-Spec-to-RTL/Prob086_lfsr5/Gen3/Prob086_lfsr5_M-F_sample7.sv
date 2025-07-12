module TopModule (
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 5'b10000; // reset to 1 at the MSB position (bit 4)
    end else begin
        q_reg[4] <= q_reg[4] ^ q_reg[2]; // update MSB with XOR of MSB and bit at position 3
        q_reg[3:1] <= q_reg[4:2]; // shift bits to the right
        q_reg[0] <= q_reg[4]; // assign the new MSB value to the LSB position
    end
end

assign q = q_reg;

endmodule